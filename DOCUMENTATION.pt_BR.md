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
  - `pt_BR` é o idioma da página ela irá definir a propridade `lang` da tag `html` de todas as páginas do projeto
  - `sources` indica onde o `Lua WPP` irá procurar as páginas Lua para gerar o HTML final
  - `output` é onde os arquivos HTML serão criados
  - `index` e `diretorio/pagina` são os arquivos que fazem parte desse projeto, note que
    - Os arquivos devem possuir a extensão `.lua`
    - Na listagem não pode ter extensão
    - Na listagem devem estar delimitados por aspas simples ou duplas
    - Os items da lista são separados por `,`
   
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
  li ^ {"Item 1","Item 2","Item 3","Item 4"}
}
```

A sintaxe da lista é uma tabela Lua delitada por chaves e os elementos são textos (`strings` em Lua) 
