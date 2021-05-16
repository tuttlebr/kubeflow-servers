clear
docker system prun
BUILD_VERSION_ARG=$1
BUILD_PREFIX="tuttlebr/kubeflow-servers/"

clearSession(){
    clear
    docker system prune -f
}

removeImage(){
    echo Removing image $BUILD_PREFIX$1:$BUILD_VERSION_ARG 
    docker rmi -f $BUILD_PREFIX$1:$BUILD_VERSION_ARG 
}


pushFunction () {
    echo ================================================================================
    echo
    echo pushing $BUILD_PREFIX$1:$BUILD_VERSION_ARG
    echo
    echo ================================================================================
    docker push \
        -t $BUILD_PREFIX$1:$BUILD_VERSION_ARG \
    echo
}

buildFunction () {
    echo ================================================================================
    echo
    echo building $BUILD_PREFIX$1:$BUILD_VERSION_ARG
    echo
    echo ================================================================================
    docker build \
        -t $BUILD_PREFIX$1:$BUILD_VERSION_ARG \
        --build-arg BUILD_VERSION_ARG=$BUILD_VERSION_ARG \
        $1 
    echo
}

clearSession

for DIR_CONFIG in $(ls -d */ | cut -f1 -d'/')
do
    removeImage $DIR_CONFIG
    buildFunction $DIR_CONFIG
done

for DIR_CONFIG in $(ls -d */ | cut -f1 -d'/')
do
    buildFunction $DIR_CONFIG
    pushFunction $DIR_CONFIG
done