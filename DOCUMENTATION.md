# Documentation

This is Lua WPP's documentation, it will assume that you have prior knowledge about HTML, if you don't [here you will find a vast amount of material about how HTML works, what each TAG does and how you should use them](https://www.w3schools.com/html/html_intro.asp), this documentation will show how to transform HTML statements into Lua tables

## Project creation

A `Lua WPP` project is nothing more than a file that lists the pages of your project with a special syntax, this approach allows you to reuse pages and components in different projects, the syntax is as follows:

```moon
Language = "pt_BR"

Pages = {
   sources = "lua-pages",
   output="www",
   'index',
   'directory/page',
}

require "lua-wpp-framework"
```

Where:
   - `pt_BR` is the language of the page it will define the `lang` property of the `html` tag of all pages of the project
   - `sources` indicates where `Lua WPP` will look for Lua pages to generate the final HTML
   - `output` is where HTML files will be created
   - `index` and `directory/page` are the files that are part of this project, note that
     - The files must have the extension `.lua`
     - The listing cannot have an extension
     - The listing must be delimited by single or double quotes
     - List items are separated by `,`
   
## The basic

A generated HTML page will only have content, if and only if, it is delimited by the HTML TAG, for example a file whose content is:

```moon
p 'Hello world'
```

Will result in a blank file

If the file content is:

```moon
html 'Hello world'
```

It will generate the following HTML:

```html
<!DOCTYPE html>
<html lang="pt_BR">
Hello World
</html>
```

## Properties and child elements

For the element to have properties and children, it must have its content between braces (`{` and `}`), they must be preceded by a name, followed by the equals symbol (`=`), the value must be enclosed in single quotes (`'`) or doubles (`"`) and must be separated by a comma (`,`) or semicolon (`;`), for example: to create a `div` element containing the `id property ` as `my-div` a `class` as `shadow pad` would look like this:

```moon
div {
   id = 'my-div',
   class = 'shadow pad',
}
```

There are 2 ways to add children and both children must be separated by a comma (`,`) or a semicolon (`;`), if the child element has no other children or properties it can be passed with the content between single quotes (`'`) or double quotes (`"`), for example: to add the TAG `h1` containing the text `Hello world` we can do it like this

```moon
div {
   id = 'my-div',
   class = 'shadow pad',
   h1 "Hello world"
}
```

If you have it, it should have its content between braces (`{` and `}`):

```moon
div {
   id = 'my-div',
   class = 'shadow pad',
   h1 "Hello world",
   P {
     "I am, ", b 'Nathanael', '!'
   }
}
```

Attention, note that the main difference between a property and a child element is the `=` sign, this example illustrates:

```moon
div {
   p = "This is a property called p",
   p 'This is a child element wrapped in the TAG p'
}
```

## Repeating elements

To repeat an element just put the asterisk sign (`*`) in front of the element followed by the quantity, immediately before the `,`:

```moon
div {
   p 'This text will be repeated 5x' * 5,
   P {
     "For elements with data between {} ", b 'works', 'like this'
   } * 3
}
```

## Merging values to elements

To interleave values to elements use the caret sign (`^`) in front of the element followed by the list, immediately before the `,`:

```moon
hello {
   li ^ {"Item 1","Item 2", b "Item 3","Item 4"}
}
```

The list syntax is a Lua table delimited by braces and the elements can be delimited by single quotes (`'`) or double quotes (`"`) or be HTML elements

## Tables

`Lua WPP` has integration with native Lua tables allowing both the traditional approach with HTML tags:

```moon
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

How much using Lua notation:

```moon
table {
   {'A1', 'B1', 'C1'},
   {'A2', 'B2', 'C2'},
   {'A3', 'B3', 'C3'},
}
```

It is possible to use combinations, mixing HTML elements and the native Lua syntax:

```moon
table {
   tr {
     td 'A1', td 'B1', td 'C1',
   },
   {'A2', b'B2', 'C2'},
   {'A3', 'B3', i'C3'},
}
```

## Reusable components

It is possible to create reusable components, this allows for a more readable and easy to maintain code on the Lua side, the creation of a new component is done through the `extends` method that is present in all elements, a component even allows changing the operating logic described above, note that as the components are going to be pre-rendered so there shouldn't be any resource overhead, it works like a smart copy and paste. To illustrate the basic concept look at the following example, it creates a component called `example` made from a `div`, which injectsta `my-class` in the `class` property and which adds a `p` component containing the text "This comes before" before the child elements of `example` and another `p` element this time with the text "This comes after ":

```moon
example = div:extends {
   class = "my-class",
   childrens = {
     first = {
        p "This one comes first"
     },
     last = {
        p "This one comes later"
     }
   }
}
```

Note that element `p` "This one comes before" is inside the `first` list that is inside the list that the `childrens` property receives, the use of the component is the same as normal TAGs:

```moon
example {
   class = "test",
   id = "experiment",
   p "This one comes in the middle"
}
```

It will generate the following HTML:

```html
<div class="mytest-class" id="experiment">
   <p>This one comes before</p>
   <p>This one comes in the middle</p>
   <p>This one comes later</p>
</div>
```

Now that you've seen the basics of component creation, we can see the most powerful feature of component creation, the `bindings`, bindings link a component property to a property of one of the children (whether in `first` or `last` , instead of passing the component directly as we did in the previous example, we create a Lua table with fields `element` and `bindings` using the following syntax:

```moon
{
   element = tag {
     class = 'example'
   },
   bindings = {
     ['child-property'] = 'component-property'
   }
}
```

Let's recreate the `checkbox` from HTML 4 passing the `identifier` property and binding it with the `id` of the child element:

```moon
checkbox = label:extends {
   childrens = {
     first = {
        {
           element = input {
             type="checkbox"
           },
           bindings = {
             ['id'] = 'identifier'
           }
        }
     }
   }
}
```

Testing:

```moon
checkbox {
   identifier = "experiment",
   "This one comes in the middle"
}
```

It will generate the following HTML:

```html
<label>
   <input id="experiment" type="checkbox">
   Tag me
</label>
```

Some observations and tips:

1. Component and child properties can be the same
2. You can extend components inside `first` and `last`
3. You can set the position of the content, to make the child of an element be the `text` property of the component do:

```moon
example = div:extends {
   childrens = {
     first = {
        {
           element = p {
             'Hello,', 'This is the second child', 'How are you?'
           },
           bindings = {
             [2] = 'text'
           }
        }
     }
   }
}
```

testing

```moon
example {
   text = "Nathanael"
}
```

Exit:

```html
<div>
   <p>Hello, Nathanael, how are you?</p>
</div>
```

> **Warning** <br>
> 1. Lua is a language based on index 1, index 3 represents the third element <br>
> 2. Place all the children until the desired index is reached, otherwise the property value will not be transmitted, for example:

```moon
example = div:extends {
   childrens = {
     first = {
        {
           element = p {
             'First second'
           },
           bindings = {
             [4] = 'text'
           }
        }
     }
   }
}
```

```moon
example {
   text="room"
}
```

Exit:

```html
<div>
   <p>First, second</p>
</div>
```

## Separation of events

`Lua WPP` maps the properties with the name starting with "on" and adds them to functions in a TAG script, this allows for greater readability of the code in the generated HTML, consider the example:

```moon
html {
    head {
       title "test"
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

It will generate the following HTML:

```html
<!DOCTYPE html>
<html lang="pt_BR">
   <head>
     <meta charset="utf8" />
     <title>test</title>
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

Note that the naming of functions depends directly on the `id` property of the element following the pattern `when_[event]_on_[id of element]`, in case an HTML element has Javascript events but does not have an `id` or a random `id` will be generated

## Special variables

You can control the behavior of `Lua WPP` by passing the value `true` to the following variables:

| Variable            | What it does?                                                                               |
|---------------------|---------------------------------------------------------------------------------------------|
| `DISABLE_UTF8`      | Disable [`charset`](https://www.w3schools.com/tags/att_meta_charset.asp)                    |
| `DISABLE_VIEWPORT`  | Disable [`viewport`](https://www.w3schools.com/css/css_rwd_viewport.asp) injection 1:1      |
| `DISABLE_GENERATOR` | Disable the injectionthe [`generator`](https://www.w3schools.com/jsref/prop_meta_name.asp)) |

> **Note:** <br>
> The use of these variables can lead to incorrect display of characters or to display breaks not being
> recommended its use being present only for exceptional cases
