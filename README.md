# JSON Parser

This is test repo that contains JSON parser done in different languages.

## Parser objectives

This parser is not meant to be performant as much as possible. It's rather experimental (for me) 
approach of writing a parser. JSON is actually simple enough to merge lexer and parser into one 
thing but for test purposes I wanted to implement both of them anyway. Key objectives that I had in mind
while designing the parser:

- Dummy lexer and parser

  These lexer and parser alone are not designed to parse json or anything else. It's done by 
  extensions provided to them during initialization. While JSON has closed specification, 
  I wanted to have parser that's easily extendable with new features. The drawback in this exact
  implementation (or maybe it's just because of JSON's simplicity?) is usually  need for making 
  both lexer and parser extensions for one thing (eg. NumberLexerExtension generating token and
  then consuming such token with NumberParserExtension)

- Modular approach

  As mentioned above, I wanted to have modular key entities to provide:
    - extendibility

      Absolutely every "feature" in JSON is done with extension to lexer/parser. Even though this
      makes parser extendable, right now I feel like it can be cumbersome for more advanced 
      language parsers if it would come to that some extensions are depended on some others. 
      Can't say for sure as I haven't yet used such approach for more advanced thing (also can't 
      say if there's already some parser done in similar and potentially better way)

    - readability

      As every tiny thing has its place in extension, it's more clean and readable (well, 
      at least I hope so)

- Self-contained

  I didn't want to use any external runtime libraries to be universal between languages

- Testing

  While I know some things about compilation process I don't have as big experience in creating 
  them to write the best parser in the world. Rather than that I wanted to:

    - Test things of how they would work
    - Check different languages in case of development process, features, complexity and 
      learning-curve

      While something could be done better in some places, I wanted to test specific language 
      features

    - Just develop some parser. I don't know, I just like this kind of things.

Also I haven't used any external sources on how to write a good parser so if this is not a good 
one in any way, I'm truly sorry.

## Architecture

As mentioned above lexer and parser are dummy and rely on extensions. There are 3 core entities:

- Scanner - scans through the source char by char
- Lexer - provides scanner to extensions to build up tokens
- Parser - provides tokens from lexer to extensions to build up structures
  
  Normally it would build up AST which would be then passed to evaluator or interpreter but
  this is not needed in case of json

### Scanner

Scanner has couple helpful methods to read chars:

```
bool isDone - tells whether scanner is done scanning i.e. it's cursor is at the end of source.

int position - current cursor's position.

int readChar() - returns ascii code of current char and moves cursor by 1.

int? peekChar([int offset]) - returns ascii code of char at index of current position + offset. 
    Does not move cursor further. This is just to lookup next char. Null if scanner is done.

bool expectString(string str) - checks whether str matches as ^str on current cursor position

void omitWhitespace() - consumes all whitespace until next non-whitespace char.

int readNonWhitespace() - consumes all whitespace and returns next char. Moves cursor by 1.

int? peekNonWhitesoace() - returns first non-whitespace char. Does not affect cursor. 
    Null if either scanner is done or there's no more non-whitespace characters after whitespaces.  
```

### Lexer

Lexer is simple entity that loops through extensions and calls their `lex` function providing a 
scanner instance. It works more-less this way:

```python    
while not scanner.isDone:
    for every extension:
        let token = extension.lex()
        
        if token is not null:
            return token
    
    throw 'unexpected char'
```

### Parser

Parser works similar to the lexer with one key difference of having `next` function provided to 
every extension. If extension decides it does not support current token it can just return 
`next()` which calls next extension in queue to try handle the token. Every next is immutable 
i.e. it would always call direct successor of actual extension and calls in next extensions won't
affect `next` from the parent:

```python
extension 1 calls next - next() points to extension 2
    extension 2 calls next - next() points to extension 3
        extension 3 returns token
    extension 2 returns received token up the ladder
extension 1 calls next once again - next() still points to extension 2
    ...
    extension 2 returns some token (either its own or from some next extension)
extension 1 now has 2 tokens
```

On top of that there's also `next.startOver` method which would reset queue of extensions in 
nested run. This is eg. to build up nested structures:

```python
// current token is "["

function ObjectExtension:
    if token is not "{":
        return next() // calls ArrayExtension
    ...
    
function ArrayExtension:
    if token is not "[":
        return next() // calls next extension in order
    else
        let items = [] 
        
        while token is not "]":
            items.add(next.startOver()) // calls again first extension in queue which in this case is ObjectExtension
```

Extensions do not know or care about order or what's previous / next extension. Calling 
`startOver` allows for utilizing nested structures like `[ {}, [ {} ] ]` etc. Without 
`next.startOver` after catching array parser wouldn't be able to parse object within array as long
as it has higher priority (i.e. its extension is before array extension in queue)

If there is anything that can be enhanced or done better in this approach I would love to hear 
that and do it eventually.
