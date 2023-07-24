# README

Based on a [course](https://github.com/alexhkurz/introduction-to-smart-contracts) at Chapman University Spring 2023 as a section of CPSC 298.

## Required Steps for Deployment

My local setup consists of [^error]

```
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash
nvm install 14
```

After cloning this directory, I run 

```
npm i 
npm run compile
```


[^error]: On my machine, without `nvm install 14` I get an error message after `npm run compile`:

    ```
    node_modules/hardhat/internal/cli/cli.js:129
        let taskName = parsedTaskName ?? task_names_1.TASK_HELP;
    
    SyntaxError: Unexpected token '?'
    at Object.compileFunction (vm.js:344:18)
    at wrapSafe (internal/modules/cjs/loader.js:1048:15)
    at Module._compile (internal/modules/cjs/loader.js:1082:27)
    at Object.Module._extensions..js (internal/modules/cjs/loader.js:1138:10)
    at Module.load (internal/modules/cjs/loader.js:982:32)
    at Function.Module._load (internal/modules/cjs/loader.js:875:14)
    at Function.executeUserEntryPoint [as runMain] (internal/modules/run_main.js:71:12)
    at internal/main/run_main_module.js:17:47
    ```

    or also (depending on circumstances I dont understand)
    
    ```
    > smartcontractframework@1.0.0 compile
    > hardhat compile
    
    WARNING: You are currently using Node.js v13.14.0, which is not supported by Hardhat. This can     lead to unexpected behavior. See https://hardhat.org/nodejs-versions
    
    /Users/alexanderkurz/alexhkurz-at-github/isc-test-5b/node_modules/hardhat/internal/cli/cli.js:66
        const viaIREnabled = configuredCompilers.some((compiler) => compiler.settings?.viaIR ===     true);
                                                                                      ^   
    SyntaxError: Unexpected token '.'
        at Object.compileFunction (vm.js:344:18)
        at wrapSafe (internal/modules/cjs/loader.js:1048:15)
        at Module._compile (internal/modules/cjs/loader.js:1082:27)
        at Object.Module._extensions..js (internal/modules/cjs/loader.js:1138:10)
        at Module.load (internal/modules/cjs/loader.js:982:32)
        at Function.Module._load (internal/modules/cjs/loader.js:875:14)
        at Module.require (internal/modules/cjs/loader.js:1022:19)
        at require (internal/modules/cjs/helpers.js:72:18)
        at Object.<anonymous> (/Users/alexanderkurz/alexhkurz-at-github/isc-test-5b/node_modules/    hardhat/internal/cli/bootstrap.js:15:1)
        at Module._compile (internal/modules/cjs/loader.js:1118:30)
    ```