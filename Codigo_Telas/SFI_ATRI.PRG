/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFI_ATRI.PRG
 \ Data....: 23-01-97
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Define atributos dos arquivos (sistema[])
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "sfin.ch"      // inicializa constantes manifestas


/*
   A adicao das  definicoes dos campos (mascara, titulo, cmd esp, when/defa,
   critica, ajuda) dentro do vetor sistema e' feita atraves da funcao AADD(),
   isto previne erro "memory overbooked" do CA-Clipper, durante a compilacao,
   devido a linha ser muito extensa
*/

sistema[01]={;
            "Pessoas",;                                     // opcao do menu
            "Pessoas F¡sicas/Jur¡dicas",;                   // titulo do sistema
            {"STR(codigo,04,00)","razao"},;                 // chaves do arquivo
            {"C¢digo","Nome"},;                             // titulo dos indices para consulta
            {"01","07"},;                                   // ordem campos chaves
            "FORNEC",;                                      // nome do DBF
            {"FORNEC1","FORNEC2"},;                         // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,1,5,22,78},;                               // num telas/tela atual/coordenadas
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {};                                             // formula mostradas
           }

AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "9999",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "@!",;
     /* titulo        */    "Tipo da Pessoa",;
     /* cmd especial  */    "MTAB([F-F¡sica|J-Jur¡dica],[TIPO DA PESSOA])",;
     /* default       */    "[F]",;
     /* pre-validacao */    "",;
     /* validacao     */    "tipo $ [FJ]~Tipo da Pessoa n„o aceit vel",;
     /* help do campo */    "Informe se a Pessoa ‚ F¡sica ou Jur¡dica";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "@!",;
     /* titulo        */    "Rg",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[F]",;
     /* validacao     */    "!EMPT(rg).AND.FOR_01F9(rg)~Necess rio informar RG",;
     /* help do campo */    "Informe o RG";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "@R 999.999.999-99",;
     /* titulo        */    "CPF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[F]",;
     /* validacao     */    "VDV2(cpf).or.Empty(cpf)~CPF n„o aceit vel",;
     /* help do campo */    "Informe o n£mero do cadastro de pessoa f¡sica";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "@R 99.999.999/9999-99",;
     /* titulo        */    "CGC",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[J]",;
     /* validacao     */    "VCGC(cgc).AND.FOR_04F9(cgc)~CGC n„o aceit vel",;
     /* help do campo */    "Informe o cadastro geral de contribuinte";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "@R 999.999.999.999",;
     /* titulo        */    "Inscri‡„o Estadual",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[J]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o numero da Inscri‡„o Estadual";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "",;
     /* titulo        */    "Nome",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(razao)~Necess rio informar o nome do Fornecedor",;
     /* help do campo */    "Informar o nome do Fornecedor";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "",;
     /* titulo        */    "Profiss„o/rea de Atua‡„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informar a profiss„o (Pessoa F¡sica) ou| rea de atua‡„o (Pessoa Jur¡dica)";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "@D",;
     /* titulo        */    "Data de Nasc./Abertura",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informar a data de nascimento (Pessoa F¡sica) ou|data de abertura (Pessoa Jur¡dica)";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "",;
     /* titulo        */    "Nacionalidade",;
     /* cmd especial  */    "",;
     /* default       */    "'Brasileiro'",;
     /* pre-validacao */    "tipo=[F]",;
     /* validacao     */    "",;
     /* help do campo */    "Informar a nacionalidade";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "",;
     /* titulo        */    "Naturalidade",;
     /* cmd especial  */    "",;
     /* default       */    "'Taubat‚'",;
     /* pre-validacao */    "tipo=[F]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a naturalidade";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "",;
     /* titulo        */    "Endere‡o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(ender)~Necess rio informar Endere‡o",;
     /* help do campo */    "Informe o endere‡o da pessoa";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "99999",;
     /* titulo        */    "N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "numero>0~N£mero n„o aceit vel",;
     /* help do campo */    "Informe o n£mero da residencia ou pr‚dio";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cep)~Necess rio informar CEP",;
     /* help do campo */    "Entre com o CEP relativo ao endere‡o";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "",;
     /* titulo        */    "Complemento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o complemento do endere‡o|bloco, quadra, etc|se houver";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o bairro do endere‡o";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "[Taubat‚]",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a Cidade do endere‡o";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "!!",;
     /* titulo        */    "UF",;
     /* cmd especial  */    "",;
     /* default       */    "[SP]",;
     /* pre-validacao */    "",;
     /* validacao     */    "VUF(uf)~Unidade da Federe‡„o inv lida",;
     /* help do campo */    "Informe a sigla da unidade da federa‡„o";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "@R (!999)!!99-9999",;
     /* titulo        */    "Fax",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero do Fax";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "@R (!999)!!99-9999",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o telefone";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "",;
     /* titulo        */    "Ramal",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o ramal do telefone|se houver";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "",;
     /* titulo        */    "Contato",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[J]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o nome do contato da Pessoa Jur¡dica";
                         };
)
AADD(sistema[01,O_CAMPO],{;            // FORNEC
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[01,O_FORMULA],{;          // FORNEC - comtipo
     /* form mostrar  */    "LEFT(TRAN(if(tipo=[F],[¡sica],[ur¡dica]),[@!]),07)",;
     /* lin da formula*/    5,;
     /* col da formula*/    17;
                         };
)

sistema[02]={;
            "Pessoas",;                                     // opcao do menu
            "Pessoas F¡sicas/Jur¡dicas",;                   // titulo do sistema
            {"STR(codigo,04,00)","razao"},;                 // chaves do arquivo
            {"C¢digo","Nome"},;                             // titulo dos indices para consulta
            {"01","08"},;                                   // ordem campos chaves
            "CLIENTES",;                                    // nome do DBF
            {"CLIENTE1","CLIENTE2"},;                       // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,1,4,22,77},;                               // num telas/tela atual/coordenadas
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {};                                             // formula mostradas
           }

AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "9999",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "@!",;
     /* titulo        */    "Tipo da Pessoa",;
     /* cmd especial  */    "MTAB([F-F¡sica|J-Jur¡dica],[TIPO DA PESSOA])",;
     /* default       */    "[F]",;
     /* pre-validacao */    "",;
     /* validacao     */    "tipo $ [FJ]~TIPO DA PESSOA n„o aceit vel",;
     /* help do campo */    "Informe se a Pessoa ‚ F¡sica ou Jur¡dica";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "9",;
     /* titulo        */    "Cr‚dito",;
     /* cmd especial  */    "VDBF(6,45,20,77,'CREDITO',{'codigo','tipo'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(codcre,01,00),'CREDITO',1).or.Empty(codcre)~Cr‚dito n„o existe na tabela",;
     /* help do campo */    "INforme o c¢digo do tipo de|classifica‡„o para cr‚dito|[F8] tabela";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "@!",;
     /* titulo        */    "Rg",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[F]",;
     /* validacao     */    "!EMPT(rg).AND.CLI_01F9(rg)~Necess rio informar RG",;
     /* help do campo */    "Informe o RG";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "@R 999.999.999-99",;
     /* titulo        */    "CPF",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[F]",;
     /* validacao     */    "Empty(cpf).or.VDV2(cpf)~CPF n„o aceit vel",;
     /* help do campo */    "Informe o n£mero do cadastro de pessoa f¡sica";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "@R 99.999.999/9999-99",;
     /* titulo        */    "CGC",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[J]",;
     /* validacao     */    "VCGC(cgc).AND.JUR_01F9(cgc)~CGC n„o aceit vel",;
     /* help do campo */    "Informe o cadastro geral de contribuinte";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "@R 999.999.999.999",;
     /* titulo        */    "Inscri‡„o Estadual",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[J]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero da Inscri‡„o Estadual";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "",;
     /* titulo        */    "Nome",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(razao)~Necess rio informar o nome do Cliente",;
     /* help do campo */    "Informar o nome do Cliente";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "",;
     /* titulo        */    "Profiss„o/rea de Atua‡„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informar a profiss„o (Pessoa F¡sica) ou| rea de atua‡„o (Pessoa Jur¡dica)";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "@D",;
     /* titulo        */    "Data de Nasc./Abertura",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informar a data de nascimento (Pessoa F¡sica) ou|data de abertura (Pessoa Jur¡dica)";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "",;
     /* titulo        */    "Nacionalidade",;
     /* cmd especial  */    "",;
     /* default       */    "'Brasileiro'",;
     /* pre-validacao */    "tipo=[F]",;
     /* validacao     */    "",;
     /* help do campo */    "Informar a nacionalidade";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "",;
     /* titulo        */    "Naturalidade",;
     /* cmd especial  */    "",;
     /* default       */    "'Taubat‚'",;
     /* pre-validacao */    "tipo=[F]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a naturalidade";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "",;
     /* titulo        */    "Endere‡o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(ender)~Necess rio informar o endere‡o",;
     /* help do campo */    "Informe o endere‡o da pessoa";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "99999",;
     /* titulo        */    "N£mero",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "numero>0~N£mero n„o aceit vel",;
     /* help do campo */    "Informe o n£mero da residencia ou pr‚dio";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "@R 99999-999",;
     /* titulo        */    "CEP",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(cep)~Necess rio informar CEP",;
     /* help do campo */    "Entre com o CEP relativo ao endere‡o";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "",;
     /* titulo        */    "Complemento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o complemento do endere‡o|bloco, quadra, etc|se houver";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "",;
     /* titulo        */    "Bairro",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o bairro do endere‡o";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "",;
     /* titulo        */    "Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "[Taubat‚]",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe a Cidade do endere‡o";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "!!",;
     /* titulo        */    "UF",;
     /* cmd especial  */    "",;
     /* default       */    "[SP]",;
     /* pre-validacao */    "",;
     /* validacao     */    "VUF(uf)~Unidade da Federe‡„o inv lida",;
     /* help do campo */    "Informe a sigla da unidade da federa‡„o";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "@R (!999)!!99-9999",;
     /* titulo        */    "Fax",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o n£mero do Fax";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "@R (!999)!!99-9999",;
     /* titulo        */    "Telefone",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o telefone";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "",;
     /* titulo        */    "Ramal",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o ramal do telefone|se houver";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "",;
     /* titulo        */    "Contato",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "tipo=[J]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o nome do contato da Pessoa Jur¡dica";
                         };
)
AADD(sistema[02,O_CAMPO],{;            // CLIENTES
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[02,O_FORMULA],{;          // CLIENTES - comtipo
     /* form mostrar  */    "LEFT(TRAN(if(tipo=[F],[¡sica],[ur¡dica]),[@!]),07)",;
     /* lin da formula*/    4,;
     /* col da formula*/    17;
                         };
)
AADD(sistema[02,O_FORMULA],{;          // CLIENTES - Nome Cr‚dito
     /* form mostrar  */    "LEFT(TRAN(CREDITO->tipo,[]),15)",;
     /* lin da formula*/    6,;
     /* col da formula*/    9;
                         };
)


sistema[03]={;
            "Caixa - Bancos",;                              // opcao do menu
            "Caixa - Bancos",;                              // titulo do sistema
            {"STR(codigo,02,00)","banco"},;                 // chaves do arquivo
            {"c¢digo","C/Corrente"},;                       // titulo dos indices para consulta
            {"01","03"},;                                   // ordem campos chaves
            "BANCOS",;                                      // nome do DBF
            {"BANCOS1","BANCOS2"},;                         // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,6,17,16,65},;                              // num telas/tela atual/coordenadas
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {};                                             // formula mostradas
           }

AADD(sistema[03,O_CAMPO],{;            // BANCOS
     /* mascara       */    "99",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "2",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // BANCOS
     /* mascara       */    "999",;
     /* titulo        */    "C¢digo Banco",;
     /* cmd especial  */    "VDBF(6,71,20,77,'TICHEQUE',{'nubanco'},1,'nubanco',[])",;
     /* default       */    "",;
     /* pre-validacao */    "codigo!=1",;
     /* validacao     */    "PTAB(codbanco,'TICHEQUE',1)~C¢digo do Banco n„o existe na tabela",;
     /* help do campo */    "Informe o c¢digo do Banco/Conta|do qual ser  emitido o cheque";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // BANCOS
     /* mascara       */    "@R 999-!!99-!!!!!!!!!-!!",;
     /* titulo        */    "Conta Corrente",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "codigo!=1",;
     /* validacao     */    "!EMPT(banco)~Necess rio informar o n£mero da conta corrente",;
     /* help do campo */    "Informe o Banco/Agˆncia/C.Corrente/Digito|Se o campo no v¡deo for maior que os n£meros a serem digitados|use espa‡os para reduzir o tamanho do campo";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // BANCOS
     /* mascara       */    "",;
     /* titulo        */    "Descri‡„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(descricao)~Necess rio informar DESCRI€ŽO",;
     /* help do campo */    "Informe o nome do banco";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // BANCOS
     /* mascara       */    "@D",;
     /* titulo        */    "Data do £ltimo Movimento",;
     /* cmd especial  */    "",;
     /* default       */    "Datac",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(datmov)~Necess rio informar Data do £ltimo Movimento",;
     /* help do campo */    "Informe a data do £ltimo movimento|ou a data do saldo atual";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // BANCOS
     /* mascara       */    "@E@X@C 999,999,999,999.99",;
     /* titulo        */    "Saldo Atual",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o Saldo Atual da Conta Corrente|o valor informado ser  lan‡ado como saldo inicial do movimento de Hoje.";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // BANCOS
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // BANCOS
     /* mascara       */    "99999999",;
     /* titulo        */    "Num.Lan‡amento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[03,O_CAMPO],{;            // BANCOS
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[04]={;
            "A‡„o Financeira",;                             // opcao do menu
            "A‡„o Financeira",;                             // titulo do sistema
            {"STR(codigo,04,00)","descricao"},;             // chaves do arquivo
            {"C¢digo Plano","Descri‡„o Plano"},;            // titulo dos indices para consulta
            {"01","02"},;                                   // ordem campos chaves
            "CONTAS",;                                      // nome do DBF
            {"CONTAS1","CONTAS2"},;                         // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,5,18,21,64,5,10},;                         // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {};                                             // formula mostradas
           }

AADD(sistema[04,O_CAMPO],{;            // CONTAS
     /* mascara       */    "9999",;
     /* titulo        */    "C¢digo da A‡„o Financeira",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "codigo>0~Necess rio informar C¢digo da Conta",;
     /* help do campo */    "Informe o C¢digo da A‡„o Financeira|Abaixo de 2000, contas de entrada|e acima de 2000, contas de sa¡da";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // CONTAS
     /* mascara       */    "",;
     /* titulo        */    "Descri‡„o A‡„o Financeira",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(descricao)~Necess rio informar Descri‡„o",;
     /* help do campo */    "Informe uma descri‡„o para a A‡„o Financeira";
                         };
)
AADD(sistema[04,O_CAMPO],{;            // CONTAS
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[05]={;
            "Hist¢rico Padr„o",;                            // opcao do menu
            "Hist¢rico Padr„o",;                            // titulo do sistema
            {"STR(codigo,03,00)"},;                         // chaves do arquivo
            {"C¢digo Hist¢rico"},;                          // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "HISTO",;                                       // nome do DBF
            {"HISTO1"},;                                    // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,6,15,21,68,5,9},;                          // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {2,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {};                                             // formula mostradas
           }

AADD(sistema[05,O_CAMPO],{;            // HISTO
     /* mascara       */    "999",;
     /* titulo        */    "C¢digo do Hist¢rico",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "codigo>0~C¢DIGO n„o aceit vel",;
     /* help do campo */    "Informe o C¢digo do Hist¢rico Padr„o";
                         };
)
AADD(sistema[05,O_CAMPO],{;            // HISTO
     /* mascara       */    "",;
     /* titulo        */    "Hist¢rico",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(descri)~Necess rio informar Hist¢rico",;
     /* help do campo */    "Informe o texto do hist¢rico padr„o";
                         };
)
AADD(sistema[05,O_CAMPO],{;            // HISTO
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[06]={;
            "Centro de Custo",;                             // opcao do menu
            "Centro de Custo",;                             // titulo do sistema
            {"STR(codigo,04,00)","departa"},;               // chaves do arquivo
            {"C¢digo C.Custo","Nome do C.Custo"},;          // titulo dos indices para consulta
            {"01","02"},;                                   // ordem campos chaves
            "CUSTO",;                                       // nome do DBF
            {"CUSTO1","CUSTO2"},;                           // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,9,15,17,66},;                              // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {};                                             // formula mostradas
           }

AADD(sistema[06,O_CAMPO],{;            // CUSTO
     /* mascara       */    "9999",;
     /* titulo        */    "C¢digo Centro de Custo",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "codigo>0~C¢digo do Centro de Custo n„o aceit vel",;
     /* help do campo */    "";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // CUSTO
     /* mascara       */    "",;
     /* titulo        */    "Departamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(departa)~Necess rio informar Departamento",;
     /* help do campo */    "Informe o nome do Departamento/rea da Empresa|relacionado com este Centro de Custo";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // CUSTO
     /* mascara       */    "@E@X@C 999,999,999,999.99",;
     /* titulo        */    "Receita",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor da Receita";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // CUSTO
     /* mascara       */    "@E@X@C 999,999,999,999.99",;
     /* titulo        */    "Despesa",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o valor da Despesa";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // CUSTO
     /* mascara       */    "@E@X@C 999,999,999,999.99",;
     /* titulo        */    "Receber",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // CUSTO
     /* mascara       */    "@E@X@C 999,999,999,999.99",;
     /* titulo        */    "Rec. Vencido",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // CUSTO
     /* mascara       */    "@E@X@C 999,999,999,999.99",;
     /* titulo        */    "Pagar",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // CUSTO
     /* mascara       */    "@E@X@C 999,999,999,999.99",;
     /* titulo        */    "Pag. Vencido",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[06,O_CAMPO],{;            // CUSTO
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[07]={;
            "Tipos de Cr‚dito",;                            // opcao do menu
            "Tipos de Cr‚dito",;                            // titulo do sistema
            {"STR(codigo,01,00)"},;                         // chaves do arquivo
            {"c¢digo"},;                                    // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "CREDITO",;                                     // nome do DBF
            {"CREDITO1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,5,18,21,61,5,10},;                         // num telas/tela atual/coordenadas/inicio scroll/qtde scroll
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {};                                             // formula mostradas
           }

AADD(sistema[07,O_CAMPO],{;            // CREDITO
     /* mascara       */    "9",;
     /* titulo        */    "C¢digo",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // CREDITO
     /* mascara       */    "@!",;
     /* titulo        */    "Tipo de Cr‚dito",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(tipo)~Necess rio informar Tipo de Cr‚dito",;
     /* help do campo */    "Informe o tipo do cr‚dito|que ser  utilizado no cadastro de clientes|com o objetivo de classifica-los quanto pagamentos recebidos";
                         };
)
AADD(sistema[07,O_CAMPO],{;            // CREDITO
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[08]={;
            "Formatos dos Cheques",;                        // opcao do menu
            "Formatos dos Cheques",;                        // titulo do sistema
            {"nubanco"},;                                   // chaves do arquivo
            {"N£mero Banco"},;                              // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "TICHEQUE",;                                    // nome do DBF
            {"TICHEQU1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,4,6,21,76},;                               // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {};                                             // formula mostradas
           }

AADD(sistema[08,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "N£mero Banco",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(nubanco)~N£nero do Banco n„o aceit vel",;
     /* help do campo */    "Informe o n£mero do Banco";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "Coluna Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "colval>0~Distƒncia para o Valor n„o aceit vel",;
     /* help do campo */    "Informe a distƒncia em mm|da margem esquerda para o valor";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "Linha Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "linval>0~Distƒncia para o Valor n„o aceit vel",;
     /* help do campo */    "Informe a distƒncia em mm|da margem superior para o Valor";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "Coluna Extenso",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "colext>0~Distƒncia para o Extenso n„o aceit vel",;
     /* help do campo */    "Informe a distƒncia em mm|da margem esquerda para o Extenso";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "Linha Extenso",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "linext>0~Distƒncia para o Extenso n„o aceit vel",;
     /* help do campo */    "Informe a distƒncia em mm|da margem superior para o Extenso";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "Coluna Ordem",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "colord>0~Distƒncia para a Ordem n„o aceit vel",;
     /* help do campo */    "Informe a distƒncia em mm|da margem esquerda para a Ordem";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "Linha Ordem",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "linord>0~Distƒncia para a Ordem n„o aceit vel",;
     /* help do campo */    "Informe a distƒncia em mm|da margem superior para a Ordem";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "Coluna Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "colcid>0~Distƒncia para a Cidade/Dia n„o aceit vel",;
     /* help do campo */    "Informe a distƒncia em mm|da margem esquerda para a Cidade/Dia";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "Coluna Mˆs",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "colmes>0~Distƒncia para o Mˆs n„o aceit vel",;
     /* help do campo */    "Informe a distƒncia em mm|da margem esquerda para o Mˆs";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "Coluna Ano",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "colano>0~Distƒncia para o Ano n„o aceit vel",;
     /* help do campo */    "Informe a distƒncia em mm|da margem esquerda para o Ano";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "999",;
     /* titulo        */    "Linha Cidade",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "lincid>0~Distƒncia para a Cidade/Dia/Mˆs/Ano n„o aceit vel",;
     /* help do campo */    "Informe a distƒncia em mm|da margem superior para a Cidade/Dia/Mˆs/Ano";
                         };
)
AADD(sistema[08,O_CAMPO],{;            // TICHEQUE
     /* mascara       */    "99999999",;
     /* titulo        */    "Ref.Tabelas",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)


sistema[09]={;
            "Movimentos Financeiros",;                      // opcao do menu
            "Movimentos Financeiros",;                      // titulo do sistema
            {"DTOS(data)+STR(banco,02,00)+STR(contas,04,00)","codlan"},;// chaves do arquivo
            {"data+Banco+Contas","Cod.Lanc"},;              // titulo dos indices para consulta
            {"010403","11"},;                               // ordem campos chaves
            "MOVIM",;                                       // nome do DBF
            {"MOVIM1","MOVIM2"},;                           // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,4,1,18,79},;                               // num telas/tela atual/coordenadas
            {1,.f.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {};                                             // formula mostradas
           }

AADD(sistema[09,O_CAMPO],{;            // MOVIM
     /* mascara       */    "@D",;
     /* titulo        */    "Data do Movimento",;
     /* cmd especial  */    "",;
     /* default       */    "DataC",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(data).and.TerCont(data)~Necess rio informar DATA DO MOVIMENTO",;
     /* help do campo */    "Informe a Data do Movimento";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // MOVIM
     /* mascara       */    "@!",;
     /* titulo        */    "Documento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(documen)~Necess rio informar o n£mero do documento",;
     /* help do campo */    "Informe o n£mero do documento a ser pago|se houver tar‡os ou barras manter na digita‡„o";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // MOVIM
     /* mascara       */    "9999",;
     /* titulo        */    "Conta",;
     /* cmd especial  */    "VDBF(6,37,20,77,'CONTAS',{'codigo','descricao'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(contas,04,00),'CONTAS',1)~Necess rio informar C¢digo da Conta",;
     /* help do campo */    "Informe o C¢digo da A‡„o Financeira|Abaixo de 2000, contas de entrada|e acima de 2000, contas de sa¡da|F8 Tabela Pick";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // MOVIM
     /* mascara       */    "99",;
     /* titulo        */    "Banco",;
     /* cmd especial  */    "VDBF(6,15,20,77,'BANCOS',{'codigo','banco','descricao'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(banco,02,00),'BANCOS',1)~BANCO n„o existe na tabela",;
     /* help do campo */    "Informe o C¢digo do Caixa/Banco|F8 Tabela Pick";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // MOVIM
     /* mascara       */    "@!",;
     /* titulo        */    "Tipo",;
     /* cmd especial  */    "MTAB([ENTRADA|SA¡DA],[TIPO])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "tipo $ [ES]~TIPO n„o aceit vel",;
     /* help do campo */    "Informe o Tipo de Opera‡„o|F8 Tabela Pick";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // MOVIM
     /* mascara       */    "999",;
     /* titulo        */    "Hist¢rico",;
     /* cmd especial  */    "VDBF(6,7,20,77,'HISTO',{'codigo','descri'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(historico,03,00),'HISTO',1).or.Empty(historico)~HIST¢RICO n„o existe na tabela",;
     /* help do campo */    "Informe C¢digo do Hist¢rico Padr„o|F8 Tabela Pick";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // MOVIM
     /* mascara       */    "@!",;
     /* titulo        */    "Complemento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o complemento do Hist¢rico|se houver";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // MOVIM
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "valor>0~VALOR n„o aceit vel",;
     /* help do campo */    "Informe o Valor";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // MOVIM
     /* mascara       */    "9999",;
     /* titulo        */    "Centro de Custos",;
     /* cmd especial  */    "VDBF(6,30,20,77,'CUSTO',{'codigo','departa'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(custo,04,00),'CUSTO',1) .or. Empty(custo)~CENTRO DE CUSTOS n„o existe na tabela",;
     /* help do campo */    "Informe o C¢digo do Centro de Custo|F8 Tabela Pick|se houver";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // MOVIM
     /* mascara       */    "",;
     /* titulo        */    "Observa‡„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe uma observa‡„o|se houver";
                         };
)
AADD(sistema[09,O_CAMPO],{;            // MOVIM
     /* mascara       */    "!!!-99999999-999-999",;
     /* titulo        */    "Cod.Lan‡amento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "I",;
     /* help do campo */    "";
                         };
)
AADD(sistema[09,O_FORMULA],{;          // MOVIM - Entrada/Sa¡da
     /* form mostrar  */    "LEFT(TRAN(If(tipo=[S],[A¡DA  ],[NTRADA]),[@!]),06)",;
     /* lin da formula*/    6,;
     /* col da formula*/    41;
                         };
)
AADD(sistema[09,O_FORMULA],{;          // MOVIM - Descri‡„o Banco
     /* form mostrar  */    "LEFT(TRAN(BANCOS->descricao,[]),30)",;
     /* lin da formula*/    6,;
     /* col da formula*/    7;
                         };
)
AADD(sistema[09,O_FORMULA],{;          // MOVIM - Descri‡„o Conta
     /* form mostrar  */    "LEFT(TRAN(CONTAS->descricao,[]),30)",;
     /* lin da formula*/    4,;
     /* col da formula*/    40;
                         };
)
AADD(sistema[09,O_FORMULA],{;          // MOVIM - Departamento
     /* form mostrar  */    "LEFT(TRAN(CUSTO->departa,[]),35)",;
     /* lin da formula*/    10,;
     /* col da formula*/    35;
                         };
)
AADD(sistema[09,O_FORMULA],{;          // MOVIM - Hist¢rico
     /* form mostrar  */    "LEFT(TRAN(HISTO->descri,[]),30)",;
     /* lin da formula*/    8,;
     /* col da formula*/    8;
                         };
)


sistema[10]={;
            "Contas a Pagar",;                              // opcao do menu
            "Contas a Pagar",;                              // titulo do sistema
            {"STR(seque,10,00)","DTOS(datapago)","STR(codigo,04,00)+documen+DTOS(vencimento)"},;// chaves do arquivo
            {"sequˆncia","Data Pagamento","for+doc+venc"},;// titulo dos indices para consulta
            {"01","14","040305"},;                          // ordem campos chaves
            "PAGAR",;                                       // nome do DBF
            {"PAGAR1","PAGAR2","PAGAR3"},;                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,1,13,23,70},;                              // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {};                                             // formula mostradas
           }

AADD(sistema[10,O_CAMPO],{;            // PAGAR
     /* mascara       */    "9999999999",;
     /* titulo        */    "Sequˆncia",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // PAGAR
     /* mascara       */    "@D",;
     /* titulo        */    "Data",;
     /* cmd especial  */    "",;
     /* default       */    "DataC",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // PAGAR
     /* mascara       */    "@!",;
     /* titulo        */    "Documento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(documen)~Necess rio informar o n£mero do documento",;
     /* help do campo */    "Informe o n£mero do documento a ser pago|se houver tar‡os ou barras manter na digita‡„o";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // PAGAR
     /* mascara       */    "9999",;
     /* titulo        */    "Fornecedor",;
     /* cmd especial  */    "VDBF(6,3,20,77,'FORNEC',{'codigo','razao','cgc','rg'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(codigo,04,00),'FORNEC',1)~Necess rio informar o C¢digo Fornecedor",;
     /* help do campo */    "Informe o c¢digo do Fornecedor|F8 Tabela Pick";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // PAGAR
     /* mascara       */    "@D",;
     /* titulo        */    "Data",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(vencimento).And.TerCont(vencimento)~Necess rio informar o vencimento",;
     /* help do campo */    "Informe a data de vencimento do documento";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // PAGAR
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Vl Pagar",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "valpagar>0~Valor n„o aceit vel",;
     /* help do campo */    "Informe o valor a ser pago";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // PAGAR
     /* mascara       */    "9999",;
     /* titulo        */    "C¢digo da A‡„o Financeira",;
     /* cmd especial  */    "VDBF(6,37,20,77,'CONTAS',{'codigo','descricao'},1,'codigo',[codigo>=2000])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(contas,04,00),'CONTAS',1)~Necess rio informar C¢digo da Conta",;
     /* help do campo */    "Informe o C¢digo da A‡„o Financeira|F8 Tabela Pick";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // PAGAR
     /* mascara       */    "99",;
     /* titulo        */    "C¢digo do Banco",;
     /* cmd especial  */    "VDBF(6,15,20,77,'BANCOS',{'codigo','banco','descricao'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(banco,02,00),'BANCOS',1).or.Empty(banco)~C¢DIGO DO BANCO n„o existe na tabela",;
     /* help do campo */    "Informe o C¢digo do Banco|F8 Tabela Pick";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // PAGAR
     /* mascara       */    "999",;
     /* titulo        */    "C¢digo do Hist¢rico",;
     /* cmd especial  */    "VDBF(6,7,20,77,'HISTO',{'codigo','descri'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(historico,03,00),'HISTO',1).or.Empty(historico)~C¢digo n„o aceit vel",;
     /* help do campo */    "Informe o C¢digo do Hist¢rico Padr„o|F8 Tabela Pick";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // PAGAR
     /* mascara       */    "9999",;
     /* titulo        */    "Centro de Custos",;
     /* cmd especial  */    "VDBF(6,15,20,77,'CUSTO',{'codigo','departa'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(custo,04,00),'CUSTO',1).or.Empty(custo)~Centro de Custos n„o existe na tabela",;
     /* help do campo */    "Informe o C¢digo do Centro de Custo|F8 Tabela Pick|se houver";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // PAGAR
     /* mascara       */    "",;
     /* titulo        */    "Observa‡„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe uma observa‡„o|se houver";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // PAGAR
     /* mascara       */    "99",;
     /* titulo        */    "N£mero da Parcela",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "parcelas>=0~N£mero da Parcela n„o aceit vel",;
     /* help do campo */    "Se for pagamentos parcelos|informe o n£mero da parcela|caso contr rio digite 0";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // PAGAR
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Valor Pago",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[10,O_CAMPO],{;            // PAGAR
     /* mascara       */    "@D",;
     /* titulo        */    "Data do Pagamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[10,O_FORMULA],{;          // PAGAR - Nome
     /* form mostrar  */    "LEFT(TRAN(FORNEC->razao,[]),35)",;
     /* lin da formula*/    6,;
     /* col da formula*/    11;
                         };
)
AADD(sistema[10,O_FORMULA],{;          // PAGAR - Descri‡„o Finan
     /* form mostrar  */    "LEFT(TRAN(CONTAS->descricao,[]),30)",;
     /* lin da formula*/    10,;
     /* col da formula*/    11;
                         };
)
AADD(sistema[10,O_FORMULA],{;          // PAGAR - Descri‡„o Banco
     /* form mostrar  */    "LEFT(TRAN(BANCOS->descricao,[]),30)",;
     /* lin da formula*/    12,;
     /* col da formula*/    9;
                         };
)
AADD(sistema[10,O_FORMULA],{;          // PAGAR - Hist¢rico Padr.
     /* form mostrar  */    "LEFT(TRAN(HISTO->descri,[]),30)",;
     /* lin da formula*/    14,;
     /* col da formula*/    10;
                         };
)
AADD(sistema[10,O_FORMULA],{;          // PAGAR - Centro Custo
     /* form mostrar  */    "LEFT(TRAN(CUSTO->departa,[]),35)",;
     /* lin da formula*/    16,;
     /* col da formula*/    11;
                         };
)


sistema[11]={;
            "Contas a Receber",;                            // opcao do menu
            "Contas a Receber",;                            // titulo do sistema
            {"STR(seque,10,00)"},;                          // chaves do arquivo
            {"Sequˆncia"},;                                 // titulo dos indices para consulta
            {"01"},;                                        // ordem campos chaves
            "RECEBER",;                                     // nome do DBF
            {"RECEBER1"},;                                  // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,1,13,23,70},;                              // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {};                                             // formula mostradas
           }

AADD(sistema[11,O_CAMPO],{;            // RECEBER
     /* mascara       */    "9999999999",;
     /* titulo        */    "Sequˆncia",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // RECEBER
     /* mascara       */    "@D",;
     /* titulo        */    "Data",;
     /* cmd especial  */    "",;
     /* default       */    "DataC",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // RECEBER
     /* mascara       */    "@!",;
     /* titulo        */    "Documento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(documen)~Necess rio informar o n£mero do documento",;
     /* help do campo */    "Informe o n£mero do documento a ser pago|se houver tar‡os ou barras manter na digita‡„o";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // RECEBER
     /* mascara       */    "9999",;
     /* titulo        */    "Cliente",;
     /* cmd especial  */    "VDBF(6,3,20,77,'CLIENTES',{'codigo','razao','cgc','rg'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(codigo,04,00),'CLIENTES',1)~Necess rio informar C¢digo do Cliente",;
     /* help do campo */    "Informe o c¢digo do Cliente|F8 Tabela Pick";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // RECEBER
     /* mascara       */    "@D",;
     /* titulo        */    "Data",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(vencimento).and.TerCont(vencimento)~Necess rio informar o vencimento",;
     /* help do campo */    "Informe a data de vencimento do documento";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // RECEBER
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Vl Pagar",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "valpagar>0~Valor n„o aceit vel",;
     /* help do campo */    "Informe o valor a ser pago";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // RECEBER
     /* mascara       */    "9999",;
     /* titulo        */    "C¢digo da Conta",;
     /* cmd especial  */    "VDBF(6,37,20,77,'CONTAS',{'codigo','descricao'},1,'codigo',[codigo<2000])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(contas,04,00),'CONTAS',1)~Necess rio informar C¢digo da Conta",;
     /* help do campo */    "Informe o C¢digo da A‡„o Financeira|F8 Tabela Pick";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // RECEBER
     /* mascara       */    "99",;
     /* titulo        */    "C¢digo do Banco",;
     /* cmd especial  */    "VDBF(6,15,20,77,'BANCOS',{'codigo','banco','descricao'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(banco,02,00),'BANCOS',1).or.Empty(banco)~C¢DIGO DO BANCO n„o existe na tabela",;
     /* help do campo */    "Informe o C¢digo do Banco|F8 Tabela Pick";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // RECEBER
     /* mascara       */    "999",;
     /* titulo        */    "C¢digo do Hist¢rico",;
     /* cmd especial  */    "VDBF(6,7,20,77,'HISTO',{'codigo','descri'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(historico,03,00),'HISTO',1).or.Empty(historico)~C¢DIGO n„o aceit vel",;
     /* help do campo */    "Informe o C¢digo do Hist¢rico Padr„o|F8 Tabela Pick";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // RECEBER
     /* mascara       */    "9999",;
     /* titulo        */    "Centro de Custos",;
     /* cmd especial  */    "VDBF(6,30,20,77,'CUSTO',{'codigo','departa'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(custo,04,00),'CUSTO',1) .or. Empty(custo)~CENTRO DE CUSTOS n„o existe na tabela",;
     /* help do campo */    "Informe o C¢digo do Centro de Custo|F8 Tabela Pick|se houver";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // RECEBER
     /* mascara       */    "",;
     /* titulo        */    "Observa‡„o",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "",;
     /* help do campo */    "Informe uma observa‡„o|se houver";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // RECEBER
     /* mascara       */    "99",;
     /* titulo        */    "N£mero da Parcela",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "parcelas>=0~N£mero da Parcela n„o aceit vel",;
     /* help do campo */    "Se for pagamentos parcelos|informe o n£mero da parcela|caso contr rio digite 0";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // RECEBER
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Valor Pago",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[11,O_CAMPO],{;            // RECEBER
     /* mascara       */    "@D",;
     /* titulo        */    "Data do Pagamento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[11,O_FORMULA],{;          // RECEBER - Raz„o Social
     /* form mostrar  */    "LEFT(TRAN(CLIENTES->razao,[]),35)",;
     /* lin da formula*/    6,;
     /* col da formula*/    11;
                         };
)
AADD(sistema[11,O_FORMULA],{;          // RECEBER - Descri‡„o Finan
     /* form mostrar  */    "LEFT(TRAN(CONTAS->descricao,[]),30)",;
     /* lin da formula*/    10,;
     /* col da formula*/    11;
                         };
)
AADD(sistema[11,O_FORMULA],{;          // RECEBER - Descri‡„o Banco
     /* form mostrar  */    "LEFT(TRAN(BANCOS->descricao,[]),30)",;
     /* lin da formula*/    12,;
     /* col da formula*/    9;
                         };
)
AADD(sistema[11,O_FORMULA],{;          // RECEBER - Hist¢rico
     /* form mostrar  */    "LEFT(TRAN(HISTO->descri,[]),30)",;
     /* lin da formula*/    14,;
     /* col da formula*/    11;
                         };
)
AADD(sistema[11,O_FORMULA],{;          // RECEBER - Departamento
     /* form mostrar  */    "LEFT(TRAN(CUSTO->departa,[]),35)",;
     /* lin da formula*/    16,;
     /* col da formula*/    13;
                         };
)


sistema[12]={;
            "Registro de Cheques",;                         // opcao do menu
            "Registro de Cheques",;                         // titulo do sistema
            {"STR(seque,10,00)","STR(codigo,04,00)+documen+DTOS(vencimento)"},;// chaves do arquivo
            {"Sequˆncia","Fornec/Doc/Venc"},;               // titulo dos indices para consulta
            {"01","030405"},;                               // ordem campos chaves
            "CHEQUES",;                                     // nome do DBF
            {"CHEQUES1","CHEQUES2"},;                       // nomes dos NTX
            {},;                                            // nome dos dbf's relacionados
            {},;                                            // campos de relacionamento
            {1,1,2,14,22,68},;                              // num telas/tela atual/coordenadas
            {1,.t.},;                                       // nivel acesso/tp chave
            {},;                                            // campos do arquivo
            {};                                             // formula mostradas
           }

AADD(sistema[12,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "9999999999",;
     /* titulo        */    "Sequˆncia",;
     /* cmd especial  */    "",;
     /* default       */    "1",;
     /* pre-validacao */    "",;
     /* validacao     */    "V",;
     /* help do campo */    "";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "@!",;
     /* titulo        */    "Interliga‡„o",;
     /* cmd especial  */    "MTAB([Sim|N„o],[INTERLIGA€ŽO])",;
     /* default       */    "[S]",;
     /* pre-validacao */    "",;
     /* validacao     */    "inter $ [SN]~Resposta inv lida",;
     /* help do campo */    "Informe se o cheque emitido ‚ de uma conta|registrada no Contas … Pagar";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "9999",;
     /* titulo        */    "Fornecedor",;
     /* cmd especial  */    "VDBF(6,27,20,77,'FORNEC',{'codigo','razao'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "inter=[S]",;
     /* validacao     */    "PTAB(STR(codigo,04,00),'FORNEC',1)~Necess rio informar C¢digo do Fornecedor",;
     /* help do campo */    "Informe o c¢digo do Fornecedor|F8 Tabela Pick";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "@!",;
     /* titulo        */    "Documento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "inter=[S]",;
     /* validacao     */    "!EMPT(documen)~Necess rio informar o n£mero do documento",;
     /* help do campo */    "Informe o n£mero do documento a ser pago|se houver tar‡os ou barras manter na digita‡„o";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "@D",;
     /* titulo        */    "Vencimento",;
     /* cmd especial  */    "VDBF(6,13,20,77,'PAGAR',{'codigo','documen','vencimento','valpagar'},3,'vencimento',[])",;
     /* default       */    "",;
     /* pre-validacao */    "inter=[S]",;
     /* validacao     */    "PTAB(STR(codigo,04,00)+documen+DTOS(vencimento),'PAGAR',3)~Necess rio informar o vencimento",;
     /* help do campo */    "Informe a data de vencimento do documento";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "99",;
     /* titulo        */    "C¢digo Banco",;
     /* cmd especial  */    "VDBF(6,15,20,77,'BANCOS',{'codigo','banco','descricao'},1,'codigo',[codigo>1])",;
     /* default       */    "",;
     /* pre-validacao */    "",;
     /* validacao     */    "PTAB(STR(codbanco,02,00),'BANCOS',1)~C¢digo do Banco n„o existe na tabela",;
     /* help do campo */    "Informe o c¢digo do Banco/Conta|do qual ser  emitido o cheque";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "@E 999,999,999,999.99",;
     /* titulo        */    "Valor",;
     /* cmd especial  */    "",;
     /* default       */    "If(inter=[S],PAGAR->valpagar,0)",;
     /* pre-validacao */    "",;
     /* validacao     */    "valor>0~Valor n„o aceit vel",;
     /* help do campo */    "Informe o valor do cheque|ou enter para aceitar o valor sugerido";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "@D",;
     /* titulo        */    "Emiss„o",;
     /* cmd especial  */    "",;
     /* default       */    "DataC",;
     /* pre-validacao */    "",;
     /* validacao     */    "!EMPT(emissao).and.TerCont(emissao)~Necess rio informar a data de emiss„o",;
     /* help do campo */    "Informe a data de emiss„o do cheque";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "@!",;
     /* titulo        */    "Favorecido",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "inter=[N]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o nome do Favorecido";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "9999",;
     /* titulo        */    "C¢digo da A‡„o Financeira",;
     /* cmd especial  */    "VDBF(6,37,20,77,'CONTAS',{'codigo','descricao'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "Paramet->lancmov=[S]",;
     /* validacao     */    "PTAB(STR(acao,04,00),'CONTAS',1)~Necess rio informar C¢digo da A‡„o Financeira",;
     /* help do campo */    "Informe o C¢digo da A‡„o Financeira|[F8] Tabela";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "999",;
     /* titulo        */    "C¢digo do Hist¢rico",;
     /* cmd especial  */    "VDBF(6,33,20,77,'HISTO',{'codigo','descri'},1,'codigo',[])",;
     /* default       */    "",;
     /* pre-validacao */    "Paramet->lancmov=[S]",;
     /* validacao     */    "PTAB(STR(histo,03,00),'HISTO',1)~C¢digo n„o aceit vel",;
     /* help do campo */    "Informe o C¢digo do Hist¢rico Padr„o|[F8] Tabela";
                         };
)
AADD(sistema[12,O_CAMPO],{;            // CHEQUES
     /* mascara       */    "@!",;
     /* titulo        */    "Complemento",;
     /* cmd especial  */    "",;
     /* default       */    "",;
     /* pre-validacao */    "Paramet->lancmov=[S]",;
     /* validacao     */    "",;
     /* help do campo */    "Informe o complemento do Hist¢rico|se houver";
                         };
)
AADD(sistema[12,O_FORMULA],{;          // CHEQUES - Fornecedor
     /* form mostrar  */    "LEFT(TRAN(FORNEC->razao,[]),40)",;
     /* lin da formula*/    6,;
     /* col da formula*/    11;
                         };
)
AADD(sistema[12,O_FORMULA],{;          // CHEQUES - cominter
     /* form mostrar  */    "LEFT(TRAN(If(inter=[S],[im],[„o]),[]),02)",;
     /* lin da formula*/    4,;
     /* col da formula*/    31;
                         };
)
AADD(sistema[12,O_FORMULA],{;          // CHEQUES - Descri‡„o A‡„o
     /* form mostrar  */    "LEFT(TRAN(CONTAS->descricao,[]),30)",;
     /* lin da formula*/    14,;
     /* col da formula*/    11;
                         };
)
AADD(sistema[12,O_FORMULA],{;          // CHEQUES - Hist¢rico
     /* form mostrar  */    "LEFT(TRAN(HISTO->descri,[]),35)",;
     /* lin da formula*/    16,;
     /* col da formula*/    11;
                         };
)

* \\ Final de SFI_ATRI.PRG
