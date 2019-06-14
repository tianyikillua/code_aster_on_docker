# Docker for Code_Aster

This repository contains the Dockerfiles for building images of [Code_Aster](https://bitbucket.org/code_aster/codeaster-src) inside a Ubuntu based system. The built images are available on [quay.io](https://quay.io/tianyikillua). Using [Docker](https://www.docker.com/) you can directly execute Code_Aster on virtually any platform (Linux, Mac, Windows, ...) and without having to compile yourself the full package (`hdf5`, `med`, `mumps`, etc).

Some files are based on the [Docker files of the FEniCS project](https://bitbucket.org/fenics-project/docker).

Currently three images are available:

1. `quay.io/tianyikillua/code_aster`: a `GCC`-based build of the latest stable version (13.6). Both the sequential and parallel (MPI) versions are available. Its size is around 3.1 GB.

```
              -- CODE_ASTER -- VERSION : EXPLOITATION (stable) --

                     Version 13.6.0 modifiée le 21/06/2018
                     révision fb950a49b96d - branche 'v13'
                         Copyright EDF R&D 1991 - 2018

                           Version de Python : 2.7.12
                           Version de NumPy : 1.11.0
                     Version de la librairie HDF5 : 1.8.14
                      Version de la librairie MED : 3.3.1
                     Version de la librairie MFront : 3.0.0
                     Version de la librairie MUMPS : 5.1.1
                    Version de la librairie PETSc : 3.7.7p0
                     Version de la librairie SCOTCH : 6.0.4
```

2. `quay.io/tianyikillua/code_aster_testing`: a `GCC`-based build of the latest testing version (14.2). Currently only the sequential version is available. Its size is around 2.3 GB.

```
        -- CODE_ASTER -- VERSION : DÉVELOPPEMENT STABILISÉE (testing) --

                     Version 14.2.0 modifiée le 21/06/2018
                   révision db2699f0662a - branche 'default'
                         Copyright EDF R&D 1991 - 2018

                           Version de Python : 2.7.12
                           Version de NumPy : 1.11.0
                     Version de la librairie HDF5 : 1.8.14
                      Version de la librairie MED : 3.3.1
                     Version de la librairie MFront : 3.1.1
                     Version de la librairie MUMPS : 5.1.2
                        Librairie PETSc : non disponible
                     Version de la librairie SCOTCH : 6.0.4
```

3. `quay.io/tianyikillua/salome_meca`: the latest release of [Salome_Meca](https://www.code-aster.org/V2/spip.php?article295) (2018). Only the sequential version is available, but `aster` is compiled with Intel compilers that in general give better performance. Additional packages such as `ecrevisse` are also provided. Unnecessary modules could in fact be removed to reduce the image size, which is currently around 4.1 GB.

| Image name                         | Build status                                                 | Description                         | Version | Size   |
| ---------------------------------- | ------------------------------------------------------------ | ----------------------------------- | ------- | ------ |
| `quay.io/tianyikillua/code_aster`  | [![Docker Repository on Quay](https://quay.io/repository/tianyikillua/code_aster/status "Docker Repository on Quay")](https://quay.io/repository/tianyikillua/code_aster) | Latest stable version of Code_Aster | 13.6    | 3.1 GB |
| `quay.io/tianyikillua/code_aster_testing`  | [![Docker Repository on Quay](https://quay.io/repository/tianyikillua/code_aster_testing/status "Docker Repository on Quay")](https://quay.io/repository/tianyikillua/code_aster_testing) | Latest testing version of Code_Aster | 14.2    | 2.3 GB |
| `quay.io/tianyikillua/salome_meca` | [![Docker Repository on Quay](https://quay.io/repository/tianyikillua/salome_meca/status "Docker Repository on Quay")](https://quay.io/repository/tianyikillua/salome_meca) | Latest release of Salome_Meca       | 2018    | 4.1 GB |

### Introduction and usage

To install Docker for your platform, follow the instructions at [docker.com](https://www.docker.com/get-docker). The [tutorial](https://docs.docker.com/get-started) provided there may also be useful.

One you have Docker installed, you can use the following commands to enjoy this Code_Aster image.

#### Preliminary verification

We can run an interactive `bash` session containing in particular the `as_run` command in its `PATH`

```sh
docker run -ti --rm quay.io/tianyikillua/code_aster
```

where `-ti` stands for an interactive process and `--rm` means the container will be automatically removed when it exits, in order to save disk space.

If everything goes well, you will see the following message showing up in the terminal

```
# Code_Aster latest stable version

Welcome to Code_Aster!

This image provides a GCC-based build of the latest
stable release of Code_Aster containing the following
components:

...

To execute an "export" file, just run

    as_run foo.export
```

To immediately verify that Code_Aster indeed works, you may launch a simple testcase (here `forma02a`)

```sh
as_run --test forma02a
```

for the sequential version, and

```sh
as_run --vers stable_mpi --test forma02a
```

for the parallel version.

#### Running simulation via `as_run` inside an interactive session

You already have all simulation files and an `export` file `test.export` defining all input/outputs in your current directory. You can first open an interactive session as before, and then run the simulation using the `as_run` command. In this case, you also need to share your current working directory into the container directory `/home/aster/shared` via the `-v` command. The `-w` command defines the starting working directory.

```sh
docker run -ti --rm -v $(pwd):/home/aster/shared -w /home/aster/shared quay.io/tianyikillua/code_aster
as_run test.export
```

The Windows users may need to replace `$(pwd)` by `%cd%`.

Of course, you need to have a correct `export` file.

1. All files should be accessible by Docker via the `/home/aster/shared` directory. They should be given using their relative path or absolute path including `/home/aster/shared`, like this

```
F comm /home/aster/shared/test.comm D 1
F mmed /home/aster/shared/test.med D 20
F mess /home/aster/shared/test.mess R 6
F resu /home/aster/shared/test.resu R 8
```

2. In order to use the parallel version, you should have

```
P version stable_mpi
```

#### Running simulation via a direct `as_run` command

You can also directly run the simulation by indicating the exact command to Docker, without opening an interactive session. Suppose you want to run `test.export`, you can directly run in your host

```sh
docker run --rm -v $(pwd):/home/aster/shared -w /home/aster/shared quay.io/tianyikillua/code_aster "/home/aster/aster/bin/as_run test.export"
```

Note that you have to specify the absolute path of `as_run` (`/home/aster/aster/bin/as_run`).

#### Running simulation via `astk`

You can also use the graphical interface `astk` to run your simulations, which will automatically write an `export` file for you.

1. For Windows users, download and open a X11 server via [MobaXterm](https://mobaxterm.mobatek.net) or [vcXsrc](https://sourceforge.net/projects/vcxsrv), etc.
2. Get your IP address (use `ipconfig` for Windows users)
3. Run the following in the directory containing simulations files

```sh
docker run -ti --rm -e DISPLAY=[YOUR IP ADDRESS]:0 -v $(pwd):/home/aster/shared -w /home/aster/shared quay.io/tianyikillua/code_aster
```

4. Run `astk` in your terminal, and voilà (see [here](https://user-images.githubusercontent.com/4027283/59491059-7323d200-8e86-11e9-8bba-13f41012236f.png)). Remember to define a `ncpus` value before running your simulation (see [here](https://user-images.githubusercontent.com/4027283/59494661-ed0b8980-8e8d-11e9-8c0e-358396dfb1ba.png)).

### Testcases qualification

A simple `run_tests.sh` script file is available at `/home/aster` that will launch all the testcases available. You can just run

```sh
./run_tests.sh
```

The test results are saved to `/home/aster/shared/test` (which will be shared with your host if you are using the `-v` command). A summary will also be given at the end.

By default it will run the sequential version `stable`. You can define an environmental variable `ASRUN` to run the parallel version `stable_mpi`

```sh
export ASRUN="/home/aster/aster/bin/as_run --vers stable_mpi"
./run_tests.sh
```

Using the sequential and parallel versions provided here, only the following tests fail mainly due to lack of some features not provided by the `aster-full` package.

- Missing `xmgrace` (20 cases)

```
forma10a  forma10b  forma30b  sdld102a  sdnl105a  sdnl105b  sdns107a  sdns107b
ssnl127a  ssnl127b  ssnl127c  ssnl127d  ssnl127e  ssnp150b  ssnp153a  ssnv194a
ssnv219b  ssnv219c  ssnv219d  tplp107b
```

- Missing `europlexus` (28 cases)

```
plexu* (except plexu10c)
```

- `gmsh` installation problem (3 cases, see [#1](../../issues/1))

```
ssls131a  zzzz151a  zzzz216b
```

- Missing `miss3d` (27 cases)

```
fdlv112b  fdlv112e  fdlv112f  fdlv112g  fdlv112k  fdlv113a  sdls118a  sdls118d
sdlv133a  sdlx101a  sdlx101b  sdlx103a  sdlx104a  sdlx105a  sdlx106a  sdnx100a
sdnx100b  sdnx100c  sdnx100d  sdnx100e  sdnx100f  sdnx100g  sdnx101a  sdnx101b
sdnx101c  zzzz108c  zzzz200b
```

- Missing `ecrevisse` (19 cases)

```
zzzz218a  zzzz218b  zzzz218c  zzzz354a  zzzz354b  zzzz354c  zzzz354d  zzzz354e
zzzz354f  zzzz354g  zzzz354h  zzzz355a  zzzz355b  zzzz355c  zzzz355d  zzzz355e
zzzz355f  zzzz355g  zzzz355h
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
hsnv131a   ort001a  ssll501a  ssna117a  ssna117b  ssna117c  ssnl121b  ssnl121c
ssnl128a  ssnl128b  ssnl128c  ssnl128d  ssnl131a  ssnl131b  ssnl131c  ssnl131d
ssnp132a  ssnv101c  ssnv113a  ssnv190a  ssnv190b  ssnv212a  ssnv213a  ssnv214a
ssnv215a  ssnv216a  zzzz118a  zzzz118b  zzzz118c  zzzz118d  zzzz120a  zzzz120b
```

- Missing `scipy` (1 case)

```
sdll151a
```

- Missing `devtools` (1 case)

```
supv002a
```

- Possible numerical issues to be investigated further (12 cases)

```
erreu06a  forma11a   rccm01b  sdnd123a  ssnp504e  ssns115b  ssnv128r  ssnv157k
supv003a  umat002a  wtnv135a  zzzz255b
```

### Performance

On a Windows 10 host with 8 Intel(R) Xeon(R) W-2123 CPU @ 3.6 GHz, with the [Docker Community Edition for Windows](https://store.docker.com/editions/community/docker-ce-desktop-windows), the following strong scaling result is obtained for the [perf009d](https://www.code-aster.org/V2/spip.php?article260) testcase.

![](https://user-images.githubusercontent.com/4027283/41157663-dfb66bc8-6b26-11e8-8706-98c186812d71.png)

Similarly, for the [perf015](https://www.code-aster.org/V2/spip.php?article662) testcases, we obtain

![](https://user-images.githubusercontent.com/4027283/41162091-2b9c7506-6b35-11e8-9808-d02c99358ff7.png)

Since back-end virtualization may still be used by Docker under Mac and Windows, performance should be better under a native Linux environment using Docker.

### Author

[Tianyi Li](https://www.linkedin.com/in/tianyikillua) ([tianyikillua@gmail.com](mailto:tianyikillua@gmail.com)) @ [Promold](https://www.linkedin.com/company/promold-paris)
