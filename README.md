# WordPress Development Container
Base config for wordpress/php development
## Instructions
* Add `ghcr.io/nziswano/wp-devcontainer:latest` as the image for your custom .devcontainer file

## Settings
```json
"settings": {
        "sqltools.connections": [
          {
            "name": "Container database",
            "driver": "MariaDB",
            "server": "wordpressdb",
            "previewLimit": 50,
            "port": 3306,
            "database": "wordpress",
            "username": "wordpress",
            "password": "wordpress"
          }
        ]
      },
      "files.associations": {
        "*.html": "twig"
      },
      "editor.defaultFormatter": "esbenp.prettier-vscode",
      "prettier.resolveGlobalModules": true,
      "emmet.includeLanguages": {
        "twig": "html",
        "nunjucks": "html"
      },
      "emmet.triggerExpansionOnTab": true,
      "emmet.showAbbreviationSuggestions": true,
      "emmet.showSuggestionsAsSnippets": true,
      "editor.formatOnSave": true,
      "files.autoSave": "onWindowChange",
      "editor.tabSize": 2,
      "files.trimTrailingWhitespace": true,
      "[markdown]": {
        "files.trimTrailingWhitespace": false
      },
      "editor.wordWrap": "wordWrapColumn",
      "terminal.integrated.defaultProfile.osx": "zsh",
      "workbench.iconTheme": "vscode-icons",
      "workbench.sideBar.location": "right",
      "editor.acceptSuggestionOnEnter": "on",
      "search.exclude": {
        "**/.yarn": true,
        "**/.pnp.*": true
      },
      "typescript.tsdk": ".yarn/sdks/typescript/lib",
      "typescript.enablePromptUseWorkspaceTsdk": true
  ```
