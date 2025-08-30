# citar sem macro

Na wikipedia Portuguesa usa-se bastante uma macro chamada `{{Citar web}}` que é
usada para gerar citações (referências para páginas web). Um problema que pode
acontecer com o seu uso, contudo, é que a macro é um bocadito intensiva no seu
uso, e numa página com milhares de citações isso pode ser problemático.

Uma explicação técnica e mais detalhada do porquê pode ser [lida na
mediawiki](https://www.mediawiki.org/wiki/Manual:Template_limits#Expensive_parser_function_calls)
mas para aqui o que interessa saber é que páginas com "demasiadas" citações
usando esta macro podem acabar por não ter as citações a serem produzidas
correctamente na página fazendo com que os leitores deixem de ter o texto sobre
a citação ou mesmo o link para a página em questão, e vejam apenas
```
#invoke:Citar web
Predefinição:Citar web
```

Para "resolver" isso, pode-se transformar as chamadas à macro em referências
com o texto corrido, mantendo o formato mas passando a ter directamente o
conteúdo (não é que as citações costumem ser actualizadas com muita
regularidade, seja como for). Um "problema" com essa solução é que estamos a
falar de milhares de citações, e possivelmente umas centenas delas a terem de
ser transformadas. Assim, apareceu este script, que serve para resolver uma boa
parte delas - os casos mais simples de uso do {{Citar web}}. Recebendo como
entrada texto wiki, responde com o mesmo texto wiki, mas com as chamadas à
macro {{Citar web}} resolvidas, com excepções: lida com os argumentos `url`,
`acessodata`, `website` e `título`, que considera obrigatórios, lidando também
com o argumento `ultimo` mas esse é considerado opcional. Se tiver o argumento
`lingua` ignora-o. Se tiver outros argumentos, então não transforma o uso da
macro numa referência sem ela.

Este script é escrito em Perl, e foi testado na versão v5.34.0, em ambiente
GNU/Linux. Pode ser usado correndo `./citar-sem-macro.pl < pagina-a-mudar.txt >
resultado.txt`.

## Exemplo prático

Este script foi feito com um exemplo prático em mente: a [Lista de candidatos a
Presidente da Câmara Municipal nas eleições autárquicas portuguesas de
2025](https://pt.wikipedia.org/wiki/Lista_de_candidatos_a_Presidente_da_C%C3%A2mara_Municipal_nas_elei%C3%A7%C3%B5es_aut%C3%A1rquicas_portuguesas_de_2025).

## Licença

Este script é licenciado com a GPLv3 - a licença pode ser lida no ficheiro
[LICENSE](LICENSE). 
