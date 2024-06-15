#!/usr/bin/env bash

# NOTE: MORE SUITABLE FOR GCC COMPILER ON LINUX
# All commands will work for llvm on mac also, but there will be slight changes in their behavior

# to cleanup:
# rm -rf obj/* lib/* ./nm-outputs/* cpp-app*

mkdir nm-outputs obj lib out

## static object files
g++ -o obj/sum.o -c sum.cpp
nm obj/sum.o > ./nm-outputs/sum.o.nm

g++ -o obj/print.o -c print.cpp 
nm obj/print.o > ./nm-outputs/print.o.nm

g++ -o obj/cpp-main.o -c cpp-main.cpp 
nm obj/cpp-main.o > ./nm-outputs/cpp-main.o.nm

# linking step
# g++ also takes care of linking standard shared libraries such as iostream
# running `ld` directly on the object files will fail, since we can't pass all the shared object files names necessary to link
g++ -o cpp-app obj/print.o obj/sum.o obj/cpp-main.o
nm cpp-app > ./nm-outputs/cpp-app.nm

## shared libraries
# output names must be lib(name).so so that while linking we can pass -l(name)
g++ -shared -fPIC -o lib/libsum.so sum.cpp
nm lib/libsum.so > ./nm-outputs/libsum.so.nm

# print requires sum
# dynamic linking of libsum
# if LIBRARY_PATH is set AND library file name is standard, then we can use -l(name)
# pass `-z defs` to force compiler to resolve all undefined symbols
g++ -shared -fPIC -o lib/libprint.so print.cpp -lsum -Llib
nm lib/libprint.so > ./nm-outputs/libprint.so.nm

# vs static linking of sum.o
g++ -shared -fPIC -o lib/libprint.sum-static.so print.cpp obj/sum.o
nm lib/libprint.sum-static.so > ./nm-outputs/libprint.sum-static.so.nm

# linking shared libraries with main app
# we don't need to pass -lsum as libprint.so already knows about -lsum
# but linker will not be able to find -lsum
# so we still need to pass -Wl,-rpath-link=<path to lsum>
g++ -o cpp-app-shared cpp-main.cpp -lprint -Llib -Wl,-rpath-link=lib
nm cpp-app-shared > ./nm-outputs/cpp-app-shared.nm 
# at runtime
# cpp-app-shared requires both libprint and libsum, LD_LIBRARY_PATH must be set

# print.sym-static library has no symbols for "sum" functions as they were statically defined
# linker does not have to find libsum
# so we don't need to pass -rpath or something
g++ -fPIC -o cpp-app-shared-sum-static cpp-main.cpp -lprint.sum-static -Llib
nm cpp-app-shared-sum-static > ./nm-outputs/cpp-app-shared-sum-static.nm 
# at runtime
# cpp-app-shared-sum-static only requires libprint.sum-static, as libprint.sum-static.so already contains all the code of libsum
