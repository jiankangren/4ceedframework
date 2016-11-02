#!/bin/bash

# Setup environment variables
source custom.conf
export KUBECTL

# Get shutdown target
if [ "$1" == "all" ] || [ "$1" == "tools" ] || [ "$1" == "extractors" ] || \
   [ "$1" == "curator" ] || [ "$1" == "uploader" ]; then
	TARGET="$1"
else
	echo 'Invalid startup target (all|tools|extractors|curator|uploader).'
	exit 1
fi

# Shutdown 4CeeD's uploader 
if [ "$TARGET" == "uploader" ] || [ "$TARGET" == "all" ]; then
    echo
	echo "========Shutting down 4CeeD's uploader...========"
	echo 

	$KUBECTL delete svc t2c2uploadersvc --namespace=4ceed
	$KUBECTL delete rc t2c2uploader --namespace=4ceed
fi

# Shutdown 4CeeD's curator 
if [ "$TARGET" == "curator" ] || [ "$TARGET" == "all" ]; then
    echo
	echo "========Shutting down 4CeeD's curator...========"
	echo 

	$KUBECTL delete svc t2c2curatorsvc --namespace=4ceed
	$KUBECTL delete rc t2c2curator --namespace=4ceed
fi

# Extractors
if [ "$TARGET" == "extractors" ] || [ "$TARGET" == "all" ]; then
    echo
	echo "========Shutting down 4CeeD's extractors...========"
	echo

	$KUBECTL delete rc dm3-extractor --namespace=4ceed
	$KUBECTL delete rc afm-extractor --namespace=4ceed
	$KUBECTL delete rc image-preview-extractor --namespace=4ceed
	$KUBECTL delete rc sem-extractor --namespace=4ceed
	$KUBECTL delete rc xray-extractor --namespace=4ceed
	$KUBECTL delete rc xray-powder-extractor --namespace=4ceed
fi

# Setup tools
if [ "$TARGET" == "tools" ] || [ "$TARGET" == "all" ]; then
    echo 
	echo "========Shutting down 4CeeD's dependent tools...========"
	echo

	$KUBECTL delete svc elasticsearch --namespace=4ceed
	$KUBECTL delete rc es --namespace=4ceed
	$KUBECTL delete svc mongo --namespace=4ceed
	$KUBECTL delete rc mongo-controller --namespace=4ceed
	$KUBECTL delete svc rabbitmq-service --namespace=4ceed
	$KUBECTL delete rc rabbitmq-controller --namespace=4ceed
fi

# Delete namespace
if [ "$TARGET" == "all" ]; then
	$KUBECTL delete namespace 4ceed
fi
