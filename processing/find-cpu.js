var glob = require( 'glob' )
var yaml = require('js-yaml')
var fs   = require('fs')

// Find deployment.yaml in sub directory
glob('deployments/**/deployment.yaml', function(err, files) {
    for (file in files) {
      try {
          // Load the YAML from file, pull CPU requests from first container (no sidecars)
          var yamlData = yaml.safeLoad(fs.readFileSync(files[file], 'utf8'))
          let cpu = JSON.stringify(yamlData.spec.template.spec.containers[0].resources.requests.cpu).replace(/['"]+/g, '')

          // Split the file path into client/product/app
          const path = files[file].toString().split('/')
          let client = path[1]
          let product = path[2]
          let app = path[3]

          // Multiple whole CPU cores by 1000, or strip the 'm' from the microcores
          if(cpu.endsWith("m")) {
              cpu = cpu.replace('m', '')
          } else {
              cpu = cpu * 1000
          }

          // Output in CSV without plugin due to low complexity.
          console.log(client + "," + product + "," + app + "," + cpu)
      } catch (error) {
          console.log(error)
      }
    }
});
