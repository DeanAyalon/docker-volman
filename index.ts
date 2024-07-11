#! npx ts-node

import { compose } from './src/generate-compose'

import { Command } from 'commander'
const program = new Command()

program.name('docker-volman')
    .description('Generates a container with all named volumes mounted to it, for easy volume management.')
    .version('0.1')
    .option('-k, --keep', 'Keep container running after exit')
    .option('-v, --verbose', 'Log everything for debugging')
    .action(options => {
        let {keep, verbose} = options
        // Verbose
        if (verbose) {
            console.log('Fetching available Docker volumes')
            console.log('Generating Compose file')
            console.log('Starting Volman')
        }
        // Generate compose file
        compose()
        // Start Volman 
    })
    .addHelpText('afterAll', '\nGlobal Options:\n  -v, --verbose    Log everything for debugging')

program.command('down').alias('stop')
    .description('Stop a running Volman container')
    .option('-f, --force', 'Force the Volman container down')
    .option('-k, --keep', 'Stop container, but don\'t remove it')   // Overridden by global option -k, get using program.opts()
    .action(options => {
        let {keep, verbose} = program.opts()
        let {force} = options

        console.log((force ? 'Forcing' : 'Taking') + ' Volman down')
        keep && console.log('The contianer will not be removed, to remove it, use: volman down')
    })

program.parse()