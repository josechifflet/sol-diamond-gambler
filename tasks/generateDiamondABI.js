/* global ethers hre task */

const fs = require('fs')
const path = require('path');

const basePath = '/contracts/dappartments/facets/'
const libraryBasePath = '/contracts/dappartments/libraries/'
const sharedLibraryBasePath = '/contracts/shared/libraries/'

task('diamondABI', 'Generates ABI file for diamond, includes all ABIs of facets')
  .setAction(async () => {
    let files = fs.readdirSync('.'+ basePath)
    console.log(files)
    let abi = []
    for (const file of files) {
      const jsonFile = file.replace('sol', 'json')
      let json = fs.readFileSync(`./artifacts${basePath}${file}/${jsonFile}`)
      json = JSON.parse(json)
      abi.push(...json.abi)
    }
    files = fs.readdirSync('.' + libraryBasePath)
    for (const file of files) {
      const jsonFile = file.replace('sol', 'json')
      let json = fs.readFileSync(`./artifacts${libraryBasePath}${file}/${jsonFile}`)
      json = JSON.parse(json)
      abi.push(...json.abi)
    }
    files = fs.readdirSync('.' + sharedLibraryBasePath)
    for (const file of files) {
      const jsonFile = file.replace('sol', 'json')
      let json = fs.readFileSync(`./artifacts${sharedLibraryBasePath}${file}/${jsonFile}`)
      json = JSON.parse(json)
      abi.push(...json.abi)
    }
    abi = JSON.stringify(abi)
    fs.writeFileSync('../diamondABI/diamond.json', abi)
    console.log('ABI written to diamondABI/diamond.json')
  })