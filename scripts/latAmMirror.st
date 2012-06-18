"Use Latin American Mirror"
Gofer new 
  url: 'http://dsal.cl/squeaksource/ObjectsAsMethodsWrap'; 
  package: 'ObjectAsMethodWrapper'; 
  load.

Gofer new 
  url: 'http://dsal.cl/squeaksource/MonticelloRedirect'; 
  package: 'MontiRedirect'; 
  load.

(Smalltalk at: #MRManager)
  redirectFrom: 'http://www.squeaksource.com/' 
  to: 'http://dsal.cl/squeaksource/'.

