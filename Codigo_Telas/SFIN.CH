/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFIN.CH
 \ Data....: 23-01-97
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Inicializa constantes do sistema
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "inkey.ch"            // constantes de codigos das teclas
#include "Fileio.ch"           // funcoes de leitura/gravacao de arquivo
#include "set.ch"              // constantes da funcao SETKEY()

#define NIV_CRI_LIVRE 2        // define quem podera acessar o criterio livre

/*
   As diretivas (#define) a seguir referem-se a configuracao da aplicacao

   COM_MAQCALC  cria "pop calculadora" acionada atraves da tecla F5
   COM_CALE ... cria "pop calendario"  acionado atraves da tecla F6
   COM_PROTECAO protege os arquivos ao acesso interativo dBASE
   COM_REDE ... prepara o sistema para operar em rede (multiusuario)
   COM_MOUSE .. prepara programa para funcionar com mouse (se existir)
   COM_TUTOR .. prepara aplicacao para gravar/ler macro (tutoriais)
   COM_LOCK.... cria protecao contra c¢pia
*/
#define COM_CALE
#define COM_MAQCALC
#define COM_REDE
#define COM_MOUSE
#define COM_TUTOR

/*
   Define variaveis a serem usadas na integridade referencial de
   arquivos subordinados (pai e filhos)
*/
#define INCLUI       0         // inclusao de novos registros
#define EXCLUI       1         // exclusao de registros
#define RECUPERA     2         // recupera registros
#define FORM_INVERSA 3         // exclui registros executando formula inversa
#define FORM_DIRETA  4         // recupera registros executando formula direta

/*
   Define variaveis a serem usadas na integridade referencial em
   tabelas PTAB()
*/
#define INCREMENTA .t.         // incrementa campo INTREF do arquivo pesquisado
#define DECREMENTA .f.         // decrementa campo INTREF do arquivo pesquisado

/*
   Opcoes atribuidas `a variavel do menu de cadastramento (op_menu)
*/
#define INCLUSAO  1            // inclusao de registros
#define ALTERACAO 2            // alteracao de registros (proc edit)
#define PROJECOES 3            // consulta/tela paginada (funcao edita())
#define VAR_COMPL 4            // tela de variaveis complementares
#define TEL_EXTRA 5            // tela complemetar


/*
         Ativa atributo do esquema de cor corrente
*/
#define COR_PADRAO 0            // cor padrao (drvcorpad)
#define COR_GET    1            // cor do campo/menu (drvcorget)

/*
   tipos de video para funcao cardtype()
*/
#define V_CGA   0              // video cga
#define V_MONO  1              // video mono/hercules
#define V_EGA   2              // video ega
#define V_VGA   3              // video vga

/*
   Define variaveis a serem usadas na funcao DBOX() - 'caixa de dialogo`
*/
#define E_MENU .t.             // monta menu de barra
#define E_POPMENU .f.          // monta menu pop-down
#define NAO_APAGA .f.          // nao apagar janela ao selecionar

/*
   tratamento do mouse
*/
#define ESQUERDO    1          // botao esquerdo
#define DIREITO     2          // botao direito
#define CLICK    -100          // botao esquerdo foi clicado

/*
   variaveis para serem usada na funcao SGRAFICO()
*/
#define ATIVO   1              // verifica se o SGR esta residente
#define GRAFICO 2              // chama o SGR atraves de interrupt

/*
   Define variaveis usadas para facilitar a identificacao dentro
   do vetos sistema[]
*/
#define O_MENU     1    // titulo reduzido para menus
#define O_MENS     2    // titulo do menu de subsistemas
#define O_CHAVE    3    // chaves do arquivos
#define O_CONSU    4    // titulos para menus dos indices de consulta
#define O_ORDEM    5    // numeros sequenciais dos campos nos arqs indices
#define O_ARQUI    6    // nome do arquivo de dados
#define O_INDIC    7    // nomes dos arquivos indices
#define O_DBRELA   8    // nome dos arquivos relacionados
#define O_CPRELA   9    // campos do relacionamento
#define O_TELA    10    // definicao da tela
#define   O_DEF    1    // numero de telas definidas
#define   O_ATUAL  2    // numero da tela atual
#define   O_LS     3    // linha superior da janela
#define   O_CS     4    // coluna superior da janela
#define   O_LI     5    // linha inferior da janela
#define   O_CI     6    // coluna inferior da janela
#define   O_SCROLL 7    // linha onde comeca o scroll
#define   O_QTDE   8    // quantas linhas vao rolar
#define O_OUTROS  11    // miscelanea
#define   O_NIVEL  1    // nivel de acesso do subsistema
#define   O_TPCHV  2    // tipo de chave primaria/nao primaria
#define O_CAMPO   12    // atributos dos campos do subsistema
#define   O_MASC   1    // mascara do campo
#define   O_TITU   2    // titulo do campo
#define   O_CMD    3    // comando especial (f8)
#define   O_DEFA   4    // default para o campo
#define   O_WHEN   5    // clausula when (pre validacao)
#define   O_CRIT   6    // expressao de validacao (critica)
#define   O_HELP   7    // texto de ajuda on-line do campo
#define O_FORMULA 13    // atributos das formulas do subsistema
#define   O_FORM   1    // formula a mostrar
#define   O_LINHA  2    // linha onde a formula sera' mostrada
#define   O_COLUNA 3    // coluna onde a formula sera' mostrada

/*
   Comandos criados para auxiliar o comando GET para receber mais outros
   parametro e armazenar na variavel de instancia "CARGO". Este artificio
   e' usado para guardar o texto de ajuda e o comando a executrar quando
   a techa F8 for pressionada, o valor inicial e as formulas que serao
   mostrada apos a digitacao do campo
*/
#command AJUDA <var>     =>  STORECARGO(<var>,ATAIL(getlist),1)
#command CMDF8 <var>     =>  STORECARGO(<var>,ATAIL(getlist),2)
#command DEFAULT <var>   =>  STORECARGO(<var>,ATAIL(getlist),3)
#command MOSTRA <var>    =>  STORECARGO(<var>,ATAIL(getlist),4)
#command DEFINICAO <cp>  =>  STOREALL(<cp>,ATail(GetList))

#ifdef COM_TUTOR
   #command KEYBOARD <c>                                           ;
                                                                              => if acao_mac="G" .OR. acao_mac="D"   ;
                                                                                 ;    __Keyboard( <c> )                ;
                                                                                 ; end
#endi

* \\ Final de SFIN.ch
