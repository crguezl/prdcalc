main = ()-> 
  source = original.value
  try 
    result = parse(source)
  catch result
  OUTPUT.innerHTML = JSON.stringify(result, undefined, 2)

window.onload = ()-> 
  PARSE.onclick = main
  
`
  Object.constructor.prototype.error = function (message, t) {
      t = t || this;
      t.name = "SyntaxError";
      t.message = message;
      throw t;
  };

  RegExp.prototype.bexec = function(str) {
    var i = this.lastIndex;
    var m = this.exec(str);
    if (m && m.index === i) return m;
    return null;
  };

  String.prototype.tokens = function () {
      var from;                   // The index of the start of the token.
      var i = 0;                  // The index of the current character.
      var n;                      // The number value.
      var m;                      // Matching
      var result = [];            // An array to hold the results.

      var WHITES              = /\s+/g;
      var ID                  = /[a-zA-Z_]\w*/g;
      var NUM                 = /\b\d+(\.\d*)?([eE][+-]?\d+)?\b/g;
      var STRING              = /('(\\.|[^'])*'|"(\\.|[^"])*")/g;
      var ONELINECOMMENT      = /\/\/.*/g;
      var MULTIPLELINECOMMENT = /\/[*](.|\n)*?[*]\//g;
      var ONECHAROPERATORS    = /([-+*\/=()&|;:,<>{}[\]])/g; 
      var tokens = [WHITES, ID, NUM, STRING, ONELINECOMMENT, 
                    MULTIPLELINECOMMENT,  ONECHAROPERATORS ];
      var RESERVED_WORD = { p : 'P' };


      // Make a token object.
      var make = function (type, value) {
          return {
              type: type,
              value: value,
              from: from,
              to: i
          };
      };

      var getTok = function() {
        var str = m[0];
        i += str.length; // Warning! side effect on i
        return str;
      };

      // Begin tokenization. If the source string is empty, return nothing.
      if (!this) return; 

      // Loop through this text
      while (i < this.length) {
          tokens.forEach( function(t) { t.lastIndex = i;}); // Only ECMAScript5
          from = i;
          // Ignore whitespace and comments
          if (m = WHITES.bexec(this) || 
             (m = ONELINECOMMENT.bexec(this))  || 
             (m = MULTIPLELINECOMMENT.bexec(this))) { getTok(); }
          // name.
          else if (m = ID.bexec(this)) {
              var rw = RESERVED_WORD[m[0]];
              if (rw) { result.push(make(rw, getTok())); }
              else { result.push(make('ID', getTok())); }
          } 
          // number.
          else if (m = NUM.bexec(this)) {
              n = +getTok();

              if (isFinite(n)) {
                  result.push(make('NUM', n));
              } else {
                  make('NUM', m[0]).error("Bad number");
              }
          } 
          // string
          else if (m = STRING.bexec(this)) {
              result.push(make('STRING', getTok().replace(/^["']|["']$/g,'')));
          // single-character operator
          } else if (m = ONECHAROPERATORS.bexec(this)){
              result.push(make(m[0], getTok()));
          } else {
            throw "Syntax error near '"+this.substr(i)+"'";
          }
      }
      return result;
  };

  var parse = function(input) {
    var tokens = input.tokens();
    var lookahead = tokens.shift();

    var match = function(t) {
      if (lookahead.type === t) {
        lookahead = tokens.shift();
        if (typeof lookahead === 'undefined') {
         lookahead = null;
        } else { // Error. Throw exception
        }
      }
    };

    var statements = function() {
      var result = [ statement() ];
      while (lookahead && lookahead.type === ';') {
        match(';');
        result.push(statement());
      }
      return result.length === 1? result[0] : result;
    };

    var statement = function() {
      var result = null;

      if (lookahead && lookahead.type === 'ID') {
        var left = { type: 'ID', value: lookahead.value };
        match('ID');
        match('=');
        right = expression();
        result = { type: '=', left: left, right: right };
      } else if (lookahead && lookahead.type === 'P') {
        match('P');
        right = expression();
        result = { type: 'P', value: right };
      } else { // Error!
      }
      return result;
    };

    var expression = function() {
      var result = term();
      if (lookahead && lookahead.type === '+') { 
        match('+');
        var right = expression();
        result = {type: '+', left: result, right: right};
      }
      return result;
    };

    var term = function() {
      var result = factor();
      if (lookahead && lookahead.type === '*') { 
        match('*');
        var right = term();
        result = {type: '*', left: result, right: right};
      }
      return result;
    };

    var factor = function() {
      var result = null;

      if (lookahead.type === 'NUM') { 
        result = {type: 'NUM', value: lookahead.value};
        match('NUM'); 
      }
      else if (lookahead.type === 'ID') {
        result = {type: 'ID', value: lookahead.value};
        match('ID');
      }
      else if (lookahead.type === '(') {
        match('(');
        result = expression();
        match(')');
      } else { // Throw exception
      }
      return result;
    };
    return statements(input);
  }
`
