#!/bin/bash
ver1=$1
ver2=$2

if [ $ver1 ]; then ENSEMBL_BRANCH="$ver1"; fi
if [ $ver2 ]; then EG_BRANCH="$ver2"; fi

## Check out *Ensembl* code (API, web and (web) tools) from GitHub:
for repo in \
    ensembl \
    ensembl-compara \
    ensembl-funcgen \
    ensembl-tools \
    ensembl-variation \
    ensembl-rest \
    ensembl-io;
do
    if [ ! -d "$repo" ]; then
        echo "Checking out $repo (branch ${ENSEMBL_BRANCH})"
        git clone --branch ${ENSEMBL_BRANCH} https://github.com/Ensembl/${repo}
    else
        echo Already got $repo, attempting to pull...
        cd $repo
        git pull
        git status
        cd ../
    fi

    echo
    echo
done

## Check out *Ensembl Genomes* code (API, web and (web) tools) from GitHub:
for repo in \
    ensemblgenomes-api;
do
    if [ ! -d "$repo" ]; then
        echo "Checking out $repo (branch ${EG_BRANCH})"
        git clone --branch ${EG_BRANCH} https://github.com/EnsemblGenomes/${repo}
    else
        echo Already got $repo, attempting to pull...
        cd $repo
        git pull
        git status
        cd ../
    fi

    echo
    echo
done


## Dir for starman logs and pid file
mkdir logs

## Copy default VB configs
cp -vi vectorbase-rest/vectrobase_rest.conf.default vectrobase_rest.conf
cp -vi vectorbase-rest/bin/env.sh.default env.sh

## Copy static files
cp -rv vectorbase-rest/root/static ensembl-rest/root

## Remove Ensembl versions of endpoints we fully override
rm -v ensembl-rest/root/documentation/overlap.conf
rm -v ensembl-rest/root/documentation/compara.conf

## Remove some endpoints we dont want
rm -v ensembl-rest/root/documentation/regulatory.conf
rm -v ensembl-rest/root/documentation/gavariant.conf
rm -v ensembl-rest/root/documentation/gavariantset.conf
rm -v ensembl-rest/root/documentation/gacallset.conf
rm -v ensembl-rest/root/documentation/vep.conf

## Apply /rest prefix
cp -v vectorbase-rest/root/wrapper.tt ensembl-rest/root/wrapper.tt
cp -v vectorbase-rest/root/documentation/index.tt ensembl-rest/root/documentation/index.tt
cp -v vectorbase-rest/root/documentation/info.tt ensembl-rest/root/documentation/info.tt