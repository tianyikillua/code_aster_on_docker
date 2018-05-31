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

To install Docker for your platform, follow the instructions at [docker.com](https://www.docker.com/get-docker). The [tutorial](https://docs.docker.com/get-started) provided there may also be useful.

One you have Docker installed, you can use the following commands to run the here provided Code_Aster image.

1. To run an interactive `bash` terminal containing the `as_run` command in its `PATH`:

```sh
docker run -ti --rm quay.io/tianyikillua/code_aster
```

where `-ti` stands for an interactive process and `--rm` means the container will be automatically removed when it exits, in order to save disk space.

2. If you also want to share your current working directory into the container (for instance, use `as_run` to launch a `.comm` simulation file along with all the other data files, prepared in the current directory):

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

A simple `run_tests.sh` script file is available at `/home/aster` that will run all the testcases. You can just run

```
./run_tests.sh
```

All the test results are saved to `/home/aster/shared/test` (which will be shared to your host if you are using the `-v` command when launching Docker). A summary will also be given at the end.

### Performance
