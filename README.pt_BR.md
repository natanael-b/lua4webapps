<h1 align="center">
  <img src="imgs/logo.svg" width=256 alt="GIMP">
  <br />
  Lua WPP | <a href="https://github.com/natanael-b/lua-wpp/archive/refs/heads/framework.zip">Baixar</a>
</h1>

<p align="center"><i>"Um jeito legal de criar Web Apps e páginas estáticas"</i></p>

<p align="center">
  <a href="https://github.com/natanael-b/lua-wpp/fork">
    <img height=26 alt="Crie um fork no github" src="https://img.shields.io/badge/Fork--Me-H?style=social&logo=github">
  </a>
  <img  height=26 alt="GitHub Repo stars" src="https://img.shields.io/github/stars/natanael-b/lua-wpp?style=social">
  <img  height=26 alt="Dependency free" src="https://img.shields.io/badge/Zero-Dependency-blue">
  
</p>

Um pequeno mas poderoso Framework Lua para criar Web Apps e páginas estáticas, usando uma sintaxe muito mais limpa `Lua WPP` vai te fazer esquecer o HTML o clássico Olá mundo vai de:

```HTML
<!doctype html>
<html>
  <head>
    <meta charset="utf8" />
    <title>Demonstração</title>
    <meta content="width=device-width,initial-scale=1.0" name="viewport" />
  </head>
  <body>
    <h1>Olá mundo</h1>
  </body>
</html>
```

Para:

```lua
html {
  head {
    title 'Demonstração'
  };
  body {
    h1 'Olá mundo'
  }
}
```

Com custo zero de abstração já que a página final será um HTML puro

# Como se instala?

Com um interpretador Lua instalado e configurado no seu computador, adicione o `lua-wpp`:

1. Clique em <a href="https://github.com/natanael-b/lua-wpp/archive/refs/heads/framework.zip">baixar</a>
2. Extraia o conteúdo do `zip` para alguma pasta

Simples assim, a instalação é tão simples quanto baixar e extraír um arquivo `zip` :)

# Como se usa?

Na pasta que você extraiu:

1. Crie um arquivo por exemplo `Project.lua` contendo:

```lua
Language = "pt_BR" -- Define o idioma padrão das páginas

Pages = {
  sources = "lua",
  output = "www",

  'index'
}

require "lua-wpp-framework"
```

Agora crie uma pasta chamada "lua" e nela um arquivo `index.lua` com o conteúdo:

```lua
html {
  head {
    title 'Demonstração'
  };
  body {
    h1 {
      style = "padding:9pt; background-color: #3498db; color: #ecf0f1";
      'Olá mundo'
    } * 7
  }
}
```

Ao rodar `lua5.4 Project.lua` você vai ter uma página construída em `www` com o nome "index.html" onde o texto `Olá mundo` irá aparecer 7 vezes com um fundo roxo e com a letra branca

# Recursos

Só a sintaxe mais limpa não é suficiente, `Lua WPP` trás outros recursos chave ([veja a documentação para mais detalhes](DOCUMENTATION.pt_BR.md)):

### Zero dependências

Não possuindo dependências, qualquer interpretador Lua padrão suportado é capaz de fazer o `Lua WPP` funcionar

### Minificação

Gera rcódigo HTML minificado reduz o tamanho do projeto final

### Autoseparação de código de evento

Separar o código das propriedades de evento (`onclick` por exemplo) facilita a manutenção (caso necessário) nas páginas renderizadas

### Operadores mágicos

##### Repetição

```lua
p 'Esse texto irá aparecer 5x' * 5
```

##### Intercalação

```lua
ol {
  li ^ {'Item 1','Item 2','Item 3','Item 4'}
}
```

### Interação com tabelas 2D

A essa altura você deve estar pensando que é necessário usar a clássica estrutura HTML para fazer tabelas:

```lua
table {
  tr {
    td 'A1', td 'B1', td 'C1',
  },
  tr {
    td 'A2', td 'B2', td 'C2',
  },
  tr {
    td 'A3', td 'B3', td 'C3',
  },
}
```

Mas não, com `Lua WPP` você pode simplesmente:

```lua
table {
  {'A1', 'B1', 'C1'},
  {'A2', 'B2', 'C2'},
  {'A3', 'B3', 'C3'},
}
```

Isso trás a possibilidade de criar tabelas diretamente de CSVs por exemplo

### Componentes reutilizáveis

Um dos recursos mais poderosos de `Lua WPP` permite que você crie componentes e reutilize, é o fim das cadeias gigantes de tags gerando códigos confusos:

```lua
card = div:extends {
  style = 'box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2); max-width:320px;',
  childrens = {
    first = {
       {
          element = img {
             style="width:100%"
          },
          bindings = {
             ['src'] = 'picture',
          }
       },
       {
          element = div:extends {
             style='padding: 2px 16px;',
             childrens = {
                first = {
                   {
                      element = h4,
                      bindings = {
                         [1] = 'title'
                      }
                   },
                   {
                      element = p,
                      bindings = {
                         [1] = 'description'
                      }
                   },
                }
             }
          },
          bindings = {
             ['title'] = 'title',
             ['description'] = 'description',
          }
       },
    }
  }
}
```

Apesar de que de início parça muito código para pouco resultado, o código para usar o componente fica muito mais legível:

Antes:

```lua
html {
  head {
    title 'Demonstração'
  },
  body {
    div {
      style = 'box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2); max-width:320px;',
      img {
        style = 'width:100%;',
        src = "https://www.w3schools.com/howto/img_avatar.png"
      },
      div {
        style = "padding: 2px 16px;",
        h4 'John Doe',
        p 'Architect & Engineer',
      }
    },

    div {
      style = 'box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2); max-width:320px;',
      img {
        style = 'width:100%;',
        src = "https://www.w3schools.com/howto/img_avatar2.png"
      },
      div {
        style = "padding: 2px 16px;",
        h4 'Jane Doe',
        p 'Interior Designer',
      }
    },
  }
}
```

Depois:

```lua
html {
  head {
    title 'Demonstração'
  },
  body {
    card {
      picture     = "https://www.w3schools.com/howto/img_avatar.png",
      title       = "John Doe",
      description = "Architect & Engineer"
    },
    card {
      picture     = "https://www.w3schools.com/howto/img_avatar2.png",
      title       = "Jane Doe",
      description = "Interior Designer"
    },
  }
}
```

Além disso basta alterar o componente uma vez para que todos sejam alterados, reutilização de código em HTML!
