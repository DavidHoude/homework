#!/bin/sh

# Example: Traverse the deployment/ directory looking for deployment.yaml and
# extract the total CPU requests from the file, export to CSV.

for depl in $(find deployments | grep deployment.yaml); do 
  CLIENT=$(echo $depl | awk -F '/' '{ print $2}')
  PRODUCT=$(echo $depl | awk -F '/' '{ print $3}')
  APP=$(echo $depl | awk -F '/' '{ print $4}')

  # Use grep/awk/sed to pull requests.cpu from the YAML
  RAWCPU=$(grep "[[:blank:]]*requests:$" $depl -A 2 | grep "[[:blank:]]*cpu: " | awk -F ':' '{print $2}' | sed 's/ //g')
  for cpu in ${RAWCPU}; do

    # 1 CPU can be defined as 1 or 1000m, this will convert the two to the same
    if [[ ${cpu} == *m ]]; then
      CPU=$(echo ${cpu} | sed 's/m//g')
    else
      CPU=$(echo "${cpu} * 1000" | bc)
    fi
  done

  echo ${CLIENT},${PRODUCT},${APP},${CPU}
done
