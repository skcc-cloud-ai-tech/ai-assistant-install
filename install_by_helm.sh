#!/bin/bash

cd database/opensearch/helm && \
    helm upgrade --install opensearch \
    ./opensearch \
    -n opensearch \
    --create-namespace \
    -f values-opensearch.yaml

    helm upgrade --install opensearch-dashboards \
    ./opensearch-dashboards \
    -n opensearch \
    --create-namespace \
    -f values-opensearch-dashboards.yaml && \
    cd ../../..

cd database/redis/helm && \
    helm upgrade --install redis \
    ./redis \
    -n redis \
    --create-namespace \
    -f values-redis.yaml && \
    cd ../../..
