# Data Processing

This example to to showcase the usage of standard userland tools to manipulate data, as well as examples of recreating the same functionality in NodeJS.

## Problem

YAML files for specific applications are stored in deployments/client/product/app/deployment.yaml -- We need the CPU requests to ensure they are being set explicitly and not inherited from the limit.

The CPU cores can be represented in whole cores as a an integer '1' or as 1/1000th of a core as a string with a trailing 'm' -- These should be corrected before compiled into a CSV.

### Raw
```
client1/product1/app1/deployment.yaml:
    requests:
      cpu: 1000m

client2/product1/app1/deployment.yaml:
    requests:
      cpu: 1
```

### find-cpu.sh
```
bash-3.2$ ./find-cpu.sh
client1,product1,app1,1000
client2,product1,app1,1000
```

### find-cpu.js
```
bash-3.2$ ./find-cpu.js
client1,product1,app1,1000
client2,product1,app1,1000
```
