# Provisioned Concurrency

For use in Naimuri insight/blog post:
https://www.naimuri.com/solving_java_cold_starts-2/

## Overview
AWS Lambda Provisioned Concurrency provides a manner to keep lambda instances warm, to avoid initial cold starts. However, this comes with a cash cost, and does not protect you from spikes in usage. Please see the insight for more detail.
