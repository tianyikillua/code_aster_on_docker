# Docker for Code_Aster

This repository contains the Dockerfiles for building images of [Code_Aster](https://bitbucket.org/code_aster/codeaster-src) inside a Ubuntu base system. The built images are available on [quay.io](https://quay.io/tianyikillua). Using [Docker](https://www.docker.com/) you can directly execute Code_Aster on virtually any platform (Linux, Mac, Windows, ...) and without having to compile yourself the full package (`hdf5`, `med`, `mumps`, etc).

Currently two images are available:

1. `quay.io/tianyikillua/code_aster`: a `GCC`-based build of the latest stable version (13.4). Both the sequential and parallel (MPI) versions are available. Currently only the PETSc package is not used, due to a possible conflict between the `mumps` that it uses and the `mumps` directly used by `aster`. Its size is around 4.3 GB.

```
                           Version de Python : 2.7.12
                           Version de NumPy : 1.11.0
                     Version de la librairie HDF5 : 1.8.14
                      Version de la librairie MED : 3.2.1
                     Version de la librairie MFront : 3.0.0
                     Version de la librairie MUMPS : 5.1.1
                        Librairie PETSc : non disponible
                     Version de la librairie SCOTCH : 6.0.4
```

2. `quay.io/tianyikillua/salome_meca`: the latest release of [Salome_Meca](https://www.code-aster.org/V2/spip.php?article295) (2017.0.2). Only the sequential version is available, but `aster` is compiled with Intel compilers that in general give better performance. Unnecessary modules could in fact be removed to reduce the image size, which is currently around 8 GB.

### Introduction

To install Docker for your platform, follow the instructions at [docker.com](https://www.docker.com/get-docker). The [tutorial](https://docs.docker.com/get-started) provided there may also be useful.

One you have Docker installed, you can use the following commands to run the here provided Code_Aster image.

1. To run an interactive `bash` terminal containing the `as_run` command in its `PATH`

```sh
docker run -ti --rm quay.io/tianyikillua/code_aster
```

where `-ti` stands for an interactive process and `--rm` means the container will be automatically removed when it exits, in order to save disk space.

2. If you also want to share your current working directory into the container (for instance, use `as_run` to launch a `.comm` simulation file along with all the other data files, prepared in the current directory)

```sh
docker run -ti --rm -v $(pwd):/home/aster/shared quay.io/tianyikillua/code_aster
```

The Windows users may need to use the following command

```powershell
docker run -ti --rm -v %cd%:/home/aster/shared quay.io/tianyikillua/code_aster
```

### Usage

If everything goes well, you will see the following message showing up in the terminal

```sh
# Code_Aster latest stable version

Welcome to Code_Aster!

This image provides a GCC-based build of the latest
stable release of Code_Aster containing the following
components:

...

To execute an "export" file, just run

    as_run foo.export
```

To immediately verify that Code_Aster indeed works, launch a simple testcase

```sh
as_run --test forma02a
```

for the sequential version, and

```sh
as_run --vers stable_mpi --test forma02a
```

for the parallel version.

### Testcases qualification

A simple `run_tests.sh` script file is available at `/home/aster` that will launch all the testcases available. You can just run

```
./run_tests.sh
```

The test results are saved to `/home/aster/shared/test` (which will be shared with your host if you are using the `-v` command). A summary will also be given at the end.

Using the sequential and parallel versions provided here, only the following tests fail mainly due to lack of some features not provided by the `aster-full` package.

- Missing `xmgrace` (20 cases)

```
forma10a  forma10b  forma30b  sdld102a  sdnl105a  sdnl105b  sdns107a  sdns107b  ssnl127a  ssnl127b  ssnl127c  ssnl127d  ssnl127e  ssnp150b  ssnp153a  ssnv194a  ssnv219b  ssnv219c  ssnv219d  tplp107b
```

- Missing `europlexus` (28 cases)

```
plexu* (except plexu10c)
```

- `gmsh` installation problem (3 cases, see [#1](../../issues/1))

```
ssls131a  zzzz151a  zzzz216b
```

- Missing `miss3d` (29 cases)

```
fdlv112b  fdlv112e  fdlv112f  fdlv112g  fdlv112k  fdlv113a  sdls118a  sdls118d  sdlv133a  sdlx101a  sdlx101b  sdlx103a  sdlx104a  sdlx105a  sdlx106a  sdnx100a  sdnx100b  sdnx100c  sdnx100d  sdnx100e  sdnx100f  sdnx100g  sdnx101a  sdnx101b  sdnx101c  zzzz108c  zzzz200b
```

- Missing `ecrevisse` (19 cases)

```
zzzz218a  zzzz218b  zzzz218c  zzzz354a  zzzz354b  zzzz354c  zzzz354d  zzzz354e  zzzz354f  zzzz354g  zzzz354h  zzzz355a  zzzz355b  zzzz355c  zzzz355d  zzzz355e  zzzz355f  zzzz355g  zzzz355h
```

- Missing `CALC_MAC3COEUR` (31 cases)

```
mac3c*
```

- Missing `MACR_RECAL ` (6 cases)

```
sdls121a  sdls121b  sdls121c  zzzz159b  zzzz159e  zzzz159f
```

- Missing material data (32 cases)

```
hsnv131a  ort001a  ssll501a  ssna117a  ssna117b  ssna117c  ssnl121b  ssnl121c  ssnl128a  ssnl128b  ssnl128c  ssnl128d  ssnl131a  ssnl131b  ssnl131c  ssnl131d  ssnp132a  ssnv101c  ssnv113a  ssnv190a  ssnv190b  ssnv212a  ssnv213a  ssnv214a  ssnv215a  ssnv216a  zzzz118a
zzzz118b  zzzz118c  zzzz118d  zzzz120a  zzzz120b
```

- Missing `scipy` (1 case)

```
sdll151a
```

- Missing `devtools` (1 case)

```
supv002a
```

- Possible numerical issues to be investigated further (13 cases)

```
erreu06a  forma11a  rccm01b  sdnd123a  ssnp504e  ssns115b  ssnv128r  ssnv157k  supv003a  umat002a  wtnv135a  zzzz255b  zzzz401b
```

### Performance

On a Windows 10 host with 4 Intel(R) Xeon(R) W-2123 CPU @ 3.6 GHz, with the [Docker Community Edition for Windows](https://store.docker.com/editions/community/docker-ce-desktop-windows), the following strong scaling result is obtained for the [perf0009d](https://www.code-aster.org/V2/spip.php?article260) testcase.

![](https://user-images.githubusercontent.com/4027283/40848354-3905383e-65bf-11e8-9f5b-3802a155a969.png)

Since back-end virtualization may still be used by Docker under Mac and Windows, performance should be better under a native Linux environment using Docker.

### Author

[Tianyi Li](https://www.linkedin.com/in/tianyikillua) ([tianyikillua@gmail.com](mailto:tianyikillua@gmail.com)) @ [Promold](https://www.linkedin.com/company/promold-paris)
