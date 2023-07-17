# Documentação

Essa é a documentação do Lua WPP, ela irá partir do princípio que você possui conhecimento prévio sobre HTML, caso não possua [aqui você encontra um vasto material sobre como HTML funciona, o que faz cada TAG e como você deve usar elas](https://www.w3schools.com/html/html_intro.asp), essa documentação irá mostrar como transformar instruções HTML em tabelas Lua

## Criação de projeto

Um projeto `Lua WPP` nada mais é que um arquivo que lista as páginas do seu projeto com uma sintaxe especial, essa abordagem permite que você reutilize páginas e componentes em diferentes projetos, a sintaxe é a seguinte:

```lua
Language = "pt_BR"

Pages = {
  sources = "lua-pages",
  output  = "www",
  'index',
  'diretorio/pagina',
}

require "lua-wpp-framework"
```

Onde:
  - `pt_BR` é o idioma da página ela irá definir a propriedade `lang` da tag `html` de todas as páginas do projeto
  - `sources` indica onde o `Lua WPP` irá procurar as páginas Lua para gerar o HTML final
  - `output` é onde os arquivos HTML serão criados
  - `index` e `diretorio/pagina` são os arquivos que fazem parte desse projeto, note que
    - Os arquivos devem possuir a extensão `.lua`
    - Na listagem não pode ter extensão
    - Na listagem devem estar delimitados por aspas simples ou duplas
    - Os itens da lista são separados por `,`
   
## O básico

Uma página HTML gerada somente terá conteúdo, se e apenas se, estiver delimitada pela TAG HTML, por exemplo um arquivo cujo conteúdo for:

```lua
p 'Olá mundo'
```

Resultará em um arquivo em branco

Se o conteúdo arquivo for:

```lua
html 'Olá mundo'
```

Irá gerar o seguinte HTML:

```html
<!DOCTYPE html>
<html lang="pt_BR">
Olá mundo
</html>
```

## Propriedades e elementos filhos

Para que o elemento possua propriedades e filhos ele deverá ter o seu conteúdo entre chaves (`{` e `}`), devem ser precedidas de nome, seguido do símbolo de igual (`=`), o valor deve estar entre aspas simples (`'`) ou duplas (`"`) e devem ser separados por vírgula (`,`) ou ponto-e-vírgula (`;`), por exemplo: para criar um elemento `div` contendo a propriedade `id` como `my-div` a `class` como `shadow pad` ficaria assim:

```lua
div {
  id = 'my-div',
  class = 'shadow pad',
} 
```

Para adicionar filhos existem 2 formas e em ambas os filhos devem ser separados por vírgula (`,`) ou ponto-e-vírgula (`;`), caso o elemento filho não possua outros filhos ou propriedades ele pode ser passado com o conteúdo entre aspas simples (`'`) ou duplas (`"`), por exemplo:  para adicionar a TAG `h1` contendo o texto `Olá mundo` podemos fazer assim

```lua
div {
  id = 'my-div',
  class = 'shadow pad',
  h1 "Olá mundo"
} 
```

Caso possua ele deverá ter o seu conteúdo entre chaves (`{` e `}`):

```lua
div {
  id = 'my-div',
  class = 'shadow pad',
  h1 "Olá mundo",
  p {
    "Eu sou, ", b 'Natanael ', '!'
  }
} 
```

Atenção, note que a principal diferença entre uma propriedade e um elemento filho é o sinal `=`, esse exemplo ilustra:

```lua
div {
  p = "Isso é uma propriedade chamada p",
  p 'Isso é um elemento filho envolto na TAG p'
} 
```

## Repetindo elementos

Pra repetir um elemento basta colocar o sinal de asterisco (`*`) a frente do elemento seguido pela quantidade, imediatamente antes da `,`:

```lua
div {
  p 'Esse texto será repetido 5x' * 5,
  p {
    "Para elementos com os dados entre {} ", b 'funciona', ' assim'
  } * 3
} 
```

## Intercalando valores a elementos

Pra intercalando valores a elementos use o sinal de circunflexo (`^`) a frente do elemento seguido pela lista, imediatamente antes da `,`:

```lua
ol {
  li ^ {"Item 1","Item 2", b "Item 3","Item 4"}
}
```

A sintaxe da lista é uma tabela Lua delimitada por chaves e os elementos podem ser delimitados por aspas simples (`'`) ou duplas (`"`) ou ser elementos HTML

## Tabelas

`Lua WPP` possui integração com as tabelas nativas Lua permitindo tanto a abordagem tradicional com as TAGs HTML:

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

Quanto usando a notação Lua:

```lua
table {
  {'A1', 'B1', 'C1'},
  {'A2', 'B2', 'C2'},
  {'A3', 'B3', 'C3'},
}
```

É possível utilizar combinações, mesclando elementos HTML e a sintaxe Lua nativa:

```lua
table {
  tr {
    td 'A1', td 'B1', td 'C1',
  },
  {'A2', b 'B2',  'C2'},
  {'A3',   'B3', i'C3'},
}
```

## Componentes reutilizáveis

É possível criar componentes reutilizáveis isso permite um código mais legível e fácil de manter do lado Lua, a criação de um novo componente é feita através do método `extends` que está presente em todos os elementos, um componente permite alterar inclusive a lógica de funcionamento descrita acima, note que como os componentes vão ser prérenderizados então não deve existir sobrecarga de recurso, funciona como um copiar e colar inteligente. Para ilustrar o conceito básico observe o exemplo a seguir, ele cria um componente chamado `exemplo` feito a partir de uma `div`, que injeta `minha-classe` na propriedade `class` e que adiciona um componente `p` contendo o texto "Esse vem antes" antes dos elementos filhos de `exemplo` e outro elemento `p` dessa vez com o texto "Esse vem depois":

```lua
exemplo = div:extends {
  class = "minha-classe",
  childrens = {
    first = {
       p "Esse vem antes"
    },
    last = {
       p "Esse vem depois"
    }
  }
}
```

Note que elemento `p` "Esse vem antes" está dentro da lista `first` que está dentro da lista que a propriedade `childrens` recebe, a utilização do componente é igual as TAGs normais:

```lua
exemplo {
  class = "teste",
  id = "experimento",
  p "Esse vem no meio"
}
```

Irá gerar o seguinte HTML:

```html
<div class="minha-classe teste" id="experimento">
  <p>Esse vem antes</p>
  <p>Esse vem no meio</p>
  <p>Esse vem depois</p>
</div>
```

Agora que você viu o básico da criação de componentes, podemos ver o recurso mais poderoso da criação de componentes os `bindings`, bindings ligam uma propriedade do componente a uma propriedade de um dos filhos (seja em `first` ou em `last`, ao invés de passar o componente diretamente como fizemos no exemplo anterior, criamos uma tabela Lua com os campos `element` e `bindings` usa a seguinte sintaxe:

```lua
{
  element = tag {
    class = 'exemplo'
  },
  bindings = {
    ['propriedade do filho'] = 'propriedade-do-componente'
  }
}
```

Vamos recriar o `checkbox` do HTML 4 passando a propriedade `identificador` e ligar ela com o `id` do elemento filho:

```lua
checkbox = label:extends {
  childrens = {
    first = {
       {
          element = input {
            type = "checkbox"
          },
          bindings = {
            ['id'] = 'identificador'
          }
       }
    }
  }
}
```

Testando:

```lua
checkbox {
  identificador = "experimento",
  "Esse vem no meio"
}
```

Irá gerar o seguinte HTML:

```html
<label>
  <input id="experimento" type="checkbox">
  Marque me
</label>
```

Algumas observações e dicas:

1. As propriedades do componente e do filho podem ser as mesmas
2. Você pode estender componentes dentro de `first` e `last`
3. Você pode definir a posição do conteúdo, para fazer com que o filho de um elemento seja a propriedade `text` do componente faça:

```lua
exemplo = div:extends {
  childrens = {
    first = {
       {
          element = p {
            'Olá, ', 'Esse é o segundo filho', ', tudo bem?'
          },
          bindings = {
            [2] = 'text'
          }
       }
    }
  }
}
```

Testando

```lua
exemplo {
  text = "Natanael"
}
```

Saída: 

```html
<div>
  <p>Olá, Natanael, tudo bem?</p>
</div>
```

> **Aviso** <br>
> 1. Lua é uma linguagem baseada em índice 1, o índice 3 representa o terceiro elemento <br>
> 2. Coloque todos os filhos até chegar o índice desejado, do contrário, o valor da propriedade não será transmitido, por exemplo:

```lua
exemplo = div:extends {
  childrens = {
    first = {
       {
          element = p {
            'Primeiro, ', 'segundo'
          },
          bindings = {
            [4] = 'text'
          }
       }
    }
  }
}
```

```lua
exemplo {
  text = "quarto"
}
```

Saída: 

```html
<div>
  <p>Primeiro, segundo</p>
</div>
```

## Separação de eventos

`Lua WPP` mapeia as propriedades com o nome começado em "on" e adiciona em funções em uma TAG script, isso permite uma maior legibilidade do código no HTML gerado, considere o exemplo:

```lua
html {
   head {
      title "teste"
   },
   body {
      button {
         id = "example",
         "Click me!",
         onclick = {
            "alert(self);"
         }
      }
   }
}
```

Irá gerar o seguinte HTML:

```html
<!DOCTYPE html>
<html lang="pt_BR">
  <head>
    <meta charset="utf8" />
    <title>teste</title>
    <meta name="generator" content="lua-wpp" />
    <meta name="viewport" content="width=device-width,initial-scale=1.0" />
  </head>
  <body>
    <button id="example" onclick="when_click_on_example();">
      Click me!
    </button>
    <script type="text/javascript">
function when_click_on_example() {
  var self = event.target;

  alert(self);
}
    </script>
  </body>
</html>
```

Note que a nomeação das funções dependem diretamente na propriedade `id` do elemento seguindo o padrão `when_[evento]_on_[id do elemento]`, caso um elemento HTML possua eventos Javascript porém não possua um `id` um `id` aleatório será gerado

## Variáveis especiais

Você pode controlar o comportarmento do `Lua WPP` passando o valor `true` para as seguintes variáveis:

| Variável            | O que faz?                                                                                  |
|---------------------|---------------------------------------------------------------------------------------------|
| `DISABLE_UTF8`      | Desativa a injeção do [`charset`](https://www.w3schools.com/tags/att_meta_charset.asp)      |
| `DISABLE_VIEWPORT`  | Desativa a injeção do [`viewport`](https://www.w3schools.com/css/css_rwd_viewport.asp) 1:1  |
| `DISABLE_GENERATOR` | Desativa a injeção do [`generator`](https://www.w3schools.com/jsref/prop_meta_name.asp))    |

> **Nota:** <br>
> O uso dessas variáveis pode levar a exibição incorreta de caracteres ou de quebras de visualização não sendo
> recomendada a sua utilização estando presente apenas para casos excepcionais
