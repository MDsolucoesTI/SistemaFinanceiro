/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFI_ADAP.PRG
 \ Data....: 23-07-96
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Adapta arquivos do sistema
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "sfin.ch"      // inicializa constantes manifestas

V0=SAVESCREEN(0,0,MAXROW(),79)             // tela do DOS
CLEA SCREEN                                // limpa a tela
#undef COM_PROTECAO
NAOPISCA()                                 // habilita 256 cores (ega/vga)
SETCANCEL(.f.)                             // desativa ALT-C/BREAK
SET SCOREBOARD OFF                         // habilita uso da linha 0
SET CENTURY ON                     // datas com informa‡„o do s‚culo DD/MM/AAAA
SET DATE BRIT                              // datas no formato 'britasileiro`
SET WRAP ON                                // habilita rolagem de menus
SETKEY(K_INS,{||;                          // muda tamanho do cursor quando inserindo
              IF(READINSERT(),SETCURSOR(1),SETCURSOR(3)),;
              READINSERT(!READINSERT());
             };
)


/*
   rotina utilizando funcoes em assembly para pegar o  nome do programa
   que e' colocado pelo DOS no PSP (Program Segment Prefix) do programa
   que esta sendo executado.  O segmento do ambiente esta  no  endereco
   44/45 do segmento do PSP
*/
VAL_AX("6200")                             // funcao 62h retorna segmento do PSP em BX
CALLINT("21")                              // executa interrupt 21
x=VAL_BX()                                 // pega o segmento do PSP
Sg=PEEK(x,44)+PEEK(x,45)*256               // calcula endereco do segmento de ambiente

/*
   Agora, procura no segmento de ambiente, por dois bytes ZERO seguidos.
   O nome do programa comeca 2 bytes apos os ZEROs
*/
x=0
DO WHIL .t.
   IF PEEK(Sg,x)=0                         // este e o primeiro ZERO
      IF PEEK(Sg,x+1)=0                    // se o proximo tambem for,
         x+=2                              // entao pula ambos
         EXIT                              // e sai
      ENDI
   ENDI
   x++                                     // continua procurando
ENDD
exe=""
IF PEEK(Sg,x)=1                            // se este byte = 1, entao
   x+=2                                    // o nome comeca aqui e vai
   DO WHIL PEEK(Sg,x)>0                    // at‚ encontrar outro 0
      exe+=CHR(PEEK(Sg,x))                 // pega mais uma letra do nome
      x++
   ENDD
ENDI
exe=UPPER(exe)                             // captaliza nome do programa

/*
   inicializa variaveis publicas
*/
nss=13
drvcara=CHR(32); mold="ÕÍ¸³¾ÍÔ³ÆÍµ"
drvmenucen=.f.; drvfonte=18
nemp="Denny Paulista Azevedo Filho"
nsis="Sistema Financeiro"
arqgeral="SFI"
drvcorpad="N/N*"   ; drvcorbox="W+/BG"        // cores default
drvcormsg="W+/B"   ; drvcorenf="W+/R"
drvcorget="W+/N"   ; drvcortel="W+/N"
drvcorhlp="W+/BG"  
drvtitpad="GR+/N*" ; drvtitbox="GR+/BG"       // cores dos titulos default
drvtitmsg="GR+/B"  ; drvtitenf="GR+/R"
drvtitget="GR+/N"  ; drvtittel="GR+/N"
drvtithlp="GR+/BG" 
drvexe=LEFT(exe,RAT("\",exe))
drvdbf:=drvntx:=drverr := TRATADIR(QUALDIR())
arqconf=drvexe+arqgeral+"_temp.sys"
IF FILE(arqconf)
   REST FROM (arqconf) ADDI                                // restaura configuracoes gravadas
ENDI
drvautohelp:=drvmouse:=drvsom :=.f.                        // sem ajuda ativa, sem mouse e som
SETCOLOR(drvcorpad)                                        // imprime pano de fundo
CAIXA(REPL(drvcara,9),0,0,MAXROW(),79)
SETCOLOR(drvtitbox)
CAIXA(mold,01,03,05,77)                                    // monta cabecalho do programa
SETCOLOR(drvcorbox)
@ 02,05 SAY nemp                                           // conteudo do cabecalho
@ 02,66 SAY DATE()
@ 02,57 SAY NSEM(DATE())
@ 03,05 SAY nsis
@ 04,05 SAY "ADAPTADOR DE ARQUIVOS DBF"
V1=SAVESCREEN(0,0,MAXROW(),79)                             // salva fundo/cabecalho
SETCOLOR(drvtittel)
CAIXA(mold,08,16,15,63)                                    // janela dos diretorios
@ 10,16 SAY SUBS(mold,9,1)+REPL(SUBS(mold,10,1),46)+SUBS(mold,11,1)
SETCOLOR(drvcortel)
@ 09,29 SAY "DIRET¢RIOS DE TRABALHO"                       // monta tela para receber
@ 11,18 SAY "Arquivos de dados..:"                         // os diretorios dos dados
@ 12,18 SAY "Arquivos de indices:"
@ 13,18 SAY "Arquivos de apoio..:"
@ 14,18 SAY "Arquivo de senha...:"
cn=.f.; cod_sos=4
DO WHIL !cn
   drvdbf=PADR(drvdbf,23)                                  // prepara diretorio para o get
   drvntx=PADR(drvntx,23)
   drverr=PADR(drverr,23)
   drvexe=PADR(drvexe,23)                                  // recebe diretorios
   @ 11,39 GET drvdbf PICT "@!" VALI DRVEXISTE(drvdbf)
   @ 12,39 GET drvntx PICT "@!" VALI DRVEXISTE(drvntx)
   @ 13,39 GET drverr PICT "@!" VALI DRVEXISTE(drverr)
   @ 14,39 GET drvexe PICT "@!" VALI DRVEXISTE(drvexe)
   READ
   ALERTA(1)
   msg="Prosseguir|Corrigir|Retornar ao DOS"
   op_=DBOX(msg,12,55,E_MENU,,"DIRET¢RIOS")                // confirma as informacoes
   IF op_=1                                                // se tudo certo,
      EXIT                                                 // sai do loop
   ELSEIF op_=3
      RESTSCREEN(0,0,MAXROW(),79,v0)                       // s'imbora
      SETPOS(MAXROW()-1,1)                                 // cursor na penultima linha, coluna 1
      RETU                                                 // retorna ao DOS
   ENDI
ENDD
drvdbf=TRATADIR(drvdbf)                                    // coloca "\" ao final
drvntx=TRATADIR(drvntx)                                    // do diretorio
drverr=TRATADIR(drverr)
drvexe=TRATADIR(drvexe)
ntxpw=drvexe+arqgeral+"PW"                                 // nomes dos arquivos de senhas
dbfpw=ntxpw+".SYS"
RESTSCREEN(0,0,MAXROW(),79,v1)                             // restaura cabecalho e pano de fundo
msg_veri="Verificando arquivos..."                         // pode demorar um pouco entao vamos
DBOX(msg_veri,,,,NAO_APAGA,"AGUARDE!")                     // avisar que estamos trabalhando
cod_sos=1
cps_:=ARRAY(100)                                           // armazenara' os novos conteudos dos cps
AFILL(sistema:=ARRAY(nss+1),{})                            // enche sistema[] com vetores nulos
SFI_ATRI()                                                 // enche sistema[] com atributos dos DBF

/*
   protege arquivo de dados contra acesso dBase e muda para "read-only"
*/
protdbf={|fg|pt:=fg,;                                      // torna a flag visivel no proximo "code block"
          tel_p:=SAVESCREEN(0,0,MAXROW(),79),;             // salva a tela
          DBOX("Um momento!",,,,NAO_APAGA),;               // mensagem ao usuario
          AEVAL(sistema,{|sis|;                            // executa o "code block" para cada
                          EDBF(drvdbf+;                    // um dos arquivos do vetor sistema
                              sis[O_ARQUI],pt);            // (se pt, desprotege; senao, protege)
                        };
          ),;
          RESTSCREEN(0,0,MAXROW(),79,tel_p);               // restaura a tela
        }
IF FILE(dbfpw)                                               // se existir senha
   EDBF(dbfpw,.t.)                                           // desprotege o DBF e
   estru_pw={;                                               // monta arranjo da
              {"pass"       ,"C", 6,0},;                     // estrutura do DBF
              {"nome"       ,"C",15,0},;                     // da senha em uma
              {"nace"       ,"C", 1,0},;                     // variavel de memoria
              {"exfornec"   ,"C",20,0},;
              {"exclientes" ,"C",20,0},;
              {"exbancos"   ,"C",20,0},;
              {"excontas"   ,"C",20,0},;
              {"exhisto"    ,"C",20,0},;
              {"excusto"    ,"C",20,0},;
              {"excredito"  ,"C",20,0},;
              {"exticheque" ,"C",20,0},;
              {"exmovim"    ,"C",20,0},;
              {"expagar"    ,"C",20,0},;
              {"exreceber"  ,"C",20,0},;
              {"excheques"  ,"C",20,0},;
              {"exparamet"  ,"C",20,0};
            }
   USE (dbfpw)                                               // abre antigo DBF de senhas
   stru=DBSTRUCT()                                           // le strutura do arquivo
   ok=(LEN(stru)=LEN(estru_pw))                              // verifica se qtde de cp e' igual
   IF ok                                                     // e'...
      FOR t=1 TO LEN(stru)                                   // vamos correr as duas
         IF UPPER(estru_pw[t,1])!=stru[t,1]                  // estruturas comparando
            ok=.f.                                           // o nome da cada campo
            EXIT                                             // para ver se existe
         ENDI                                                // alguma diferenca
      NEXT
   ENDI
   IF !ok                                                    // se existe diferenca entre
      USE                                                    // as estruturas dos arquivos
      bak=ntxpw+".bak"                                       // entao vamos adaptar a senha
      IF FILE(bak)                                           // se existir o arquivo temporario
         ERASE (bak)                                         // entao elimina-o
      ENDI
      RENAME (dbfpw) TO (bak)                                // cria .bak da senha
      DBCREATE(dbfpw,estru_pw)                               // cria novo DBF para as senhas
      USE (dbfpw)                                            // abre o DBF e aproveita
      APPEND FROM (bak)                                      // os dados nele digitados
      USE
      ntx=ntxpw+".ntx"                                       // elimina o indice do
      IF FILE(ntx)                                           // DBF de senhas, se
         ERASE (ntx)                                         // ele existir
      ENDI
   ENDI
   CLOSE ALL                                                 // fecha o DBF de senhas aberto
ENDI
arq_prn=drverr+"PRINTERS.DBF"                                // nome dbf de "drivers" da prn
IF FILE(arq_prn)                                           // se o arquivo de "drivers"
   estru_prn={;                                            // de impressoras existir
               {"marca" ,"C",15,0},;                       // entao vamos verificar se ele
               {"porta" ,"C", 4,0},;                       // necessita de alguma adaptacao
               {"padrao","C", 1,0},;
               {"tapg"  ,"C",40,0},;
               {"pcom"  ,"C",40,0},;
               {"tcom"  ,"C",40,0},;
               {"pc20"  ,"C",40,0},;
               {"tc20"  ,"C",40,0},;
               {"peli"  ,"C",40,0},;
               {"teli"  ,"C",40,0},;
               {"penf"  ,"C",40,0},;
               {"tenf"  ,"C",40,0},;
               {"pexp"  ,"C",40,0},;
               {"texp"  ,"C",40,0},;
               {"pde8"  ,"C",40,0},;
               {"tde8"  ,"C",40,0},;
               {"land"  ,"C",40,0},;
               {"port"  ,"C",40,0};
             }
   USE (arq_prn)                                             // abre DBF de impressoras
   IF LEN(DBSTRUCT())!=LEN(estru_prn)                        // se a qde de campos for
      USE                                                    // diferente da nova estrutura
      bak=LEFT(arq_prn,LEN(arq_prn)-3)+"bak"                 // entao vamos adaptar o DBF
      IF FILE(bak)                                           // se existir o arquivo temporario
         ERASE (bak)                                         // entao elimina-o
      ENDI
      RENAME (arq_prn) TO (bak)                              // cria .bak
      DBCREATE(arq_prn,estru_prn)                            // cria novo DBF para as impressoras
      USE (arq_prn)                                          // abre o DBF e aproveita
      APPEND FROM (bak)                                      // os dados nele digitados
      USE
   ENDI
   CLOSE ALL                                                 // fecha o DBF das impressoras aberto
ENDI
EVAL(protdbf,.t.)                                            // desprotege os DBF
FOR op_sis=1 TO nss                                          // vamos verificar quais DBF
   IF FILE(drvdbf+sistema[op_sis,O_ARQUI]+".dbf")            // necessitam ser adaptados
      dbf=drvdbf+"temp9"                                     // se existir o DBF,
      stru=LEFT(sistema[op_sis,O_ARQUI],3)+"_estr"           // cria a estrutura atual
      &stru.()                                               // em um arquivo temporario
      USE (dbf)                                              // abre DBF temporario
      estru_nov=DBSTRUCT()                                   // e captura a nova estrutura
      dbf=drvdbf+sistema[op_sis,O_ARQUI]                     // vamos fazer a mesma coisa
      USE (dbf)                                              // para capturar a antiga
      estru_vel=DBSTRUCT()                                   // estrutura do arquivo,
      USE                                                    // abrindo o DBF anterior
      ok=(LEN(estru_nov)=LEN(estru_vel))                     // se a qde de campos for
      IF ok                                                  // a mesma, entao vamos
         FOR t=1 TO LEN(estru_nov)                           // ver se os atributos dos
            FOR tt=1 TO 4                                    // dois arquivos sao iguais
               IF !(estru_nov[t,tt]==estru_vel[t,tt])        // (nome, tipo, tam, dec)
                  ok=.f.; t:=tt:= 9999
               ENDI
            NEXT
         NEXT
      ENDI
      IF !ok                                                 // se o arquivo esta' diferente
         IF !CONVERTE(op_sis,estru_nov,estru_vel)            // executa a conversao do DBF
            RESTSCREEN(0,0,MAXROW(),79,v0)                   // cancelou a adaptacao
            SETPOS(MAXROW()-1,1)                             // reposiciona cursor e
            RETU                                             // volta para o DOS
         ENDI
      ENDI
      FOR t=1 TO LEN(sistema[op_sis,O_INDIC])                // para eliminar os arquivos
         ntx=drvntx+sistema[op_sis,O_INDIC,t]+".NTX"         // de indices associados ao DBF,
         IF FILE(ntx)                                        // caso existam
            ERASE (ntx)
         ENDI
      NEXT
   ENDI
NEXT
CLOSE ALL                                                    // fecha os arquivos abertos
IF FILE(drvdbf+"temp9.dbf")                                  // se foi criado algum arquivo
   ERASE &drvdbf.temp9.dbf                                   // temporario elimina-o antes
ENDI                                                         // de retornar ao DOS

#ifndef COM_REDE
   EDBF(dbfpw,.f.)                                           // protege arquivo de senhas
#endi


#ifdef COM_PROTECAO
   EVAL(protdbf,.f.)                                         // protege DBF
#endi

ALERTA(3)                                                    // beep, beep, beep
DBOX("OK! Opera‡„o terminada",13,40,4)                     // mostra msg de fim de operacao
RESTSCREEN(0,0,MAXROW(),79,v0)                               // s'imbora
SETPOS(MAXROW()-1,1)                                         // cursor na penultima linha, coluna 1
RETU                                                         // retorna para o DOS

FUNC CONVERTE(op_sis,estru_nov,estru_vel)                    // converte DBF ...
dbf=drvdbf+sistema[op_sis,O_ARQUI]                           // DBF a converter
USE (dbf)
AFILL(cps_,"")                                               // 'cps_` e' o vetor que armazenara'
qtcps=LEN(estru_nov)                                         // os conteudos dos campos
FOR t=1 TO qtcps                                             // da nova estrutura
   i=ASCAN(estru_vel,;                                       // inicializa 'cps_` com os
             {|cp|cp[1]==estru_nov[t,1].AND.;                // conteudos da estrutura anterior
                  cp[2]==estru_nov[t,2];                     // se o campo tiver o mesmo
             };                                              // nome e tamanho da nova estrutura
     )
   IF i>0                                                    // ok! este campo e' o mesmo
      cps_[t]=estru_vel[i,1]                                 // enche 'cps_` com o nome do
   ENDI                                                      // campo da estrutura anterior
NEXT
op_a=1
DO WHIL op_a!=0
   RESTSCREEN(0,0,MAXROW(),79,v1)                            // retira msg 'aguarde...`
   msg=""                                                    // msg armazenara' as opcoes
   FOR t=1 TO qtcps                                          // de menu dos campos da
      msg+="|"+PADR(estru_nov[t,1],11)+"³ "+;                // nova estrutura e o conteudo
           PADR(cps_[t],30)                                  // que sera' colocado em
   NEXT                                                      // cada um deles
   msg =SUBS(msg,2)                                          // retira o '|` do inicio
   cod_sos=1
   msgt='ARQUIVO "'+sistema[op_sis,O_ARQUI]+;                // titulo do menu
        '"|*|ESTRUTURA    PREENCHER COM:'+SPAC(17)
   op_a=DBOX(msg,,,E_MENU,NAO_APAGA,msgt,,,op_a)             // apresenta o menu
   IF op_a>0                                                 // escolheu um campo
      cp_=cps_[op_a]
      DO WHIL .t.
         SET KEY K_F10 TO ve1_campos                          // F10 monta menu de campos
         cp_=LEFT(cp_+SPACE(250),250)                        // ate' 250 caracteres para digitar
         msg ="Entre com a express„o para preencher o campo"
         msgt='CONTEUDO DO CAMPO "'+estru_nov[op_a,1]+;
              '"|(F10=ESTRUTURA ANTERIOR)'
         cod_sos=2
         cp_=DBOX(msg,,,,NAO_APAGA,msgt,cp_,"@S50")          // recebe o novo conteudo...
         SET KEY K_F10 TO                                    // desabilita a tecla F10
         IF LASTKEY()=K_ESC                                  // se cancelou,
            EXIT                                             // retorna ao menu de campos
         ENDI
         cp_=ALLTRIM(cp_)                                    // retira os espacos do novo conteudo
         tp_crit=TYPE(cp_)                                   // se a expressao=indeterminada,
         IF tp_crit="UI"                                     // existe funcao fora da clipper.lib
            tp_crit=VALTYPE(&cp_.)                           // na expressao, logo avalia o seu
         ENDI                                                // conteudo...
         IF EMPT(cp_).OR.tp_crit==estru_nov[op_a,2]          // se o tipo da expressao
            cps_[op_a]=cp_                                   // informada for igual ao tipo
            EXIT                                             // do campo em questao,
         ENDI                                                // entao prossegue,
         ALERTA(3)                                           // caso contrario, vamos avisar
         DBOX("EXPRESSŽO ILEGAL",15)                         // que a expressao nao atende
      ENDD
   ELSE                                                      // teclou ESC, entao vamos
      msg ="Prosseguir convers„o|"+;                         // perguntar se o usuario
           "Refazer conte£do dos campos|"+;                  // quer continuar com a
           "Cancelar a opera‡„o"                             // adaptacao do DBF...
      msgt="ARQUIVO "+sistema[op_sis,O_ARQUI]
      cod_sos=3
      op_=DBOX(msg,12,45,E_MENU,,msgt)                       // apresenta menu
      IF op_=1                                               // quer continuar...
         msg='Atualizando o arquivo "'+;
             sistema[op_sis,O_ARQUI]+'"'                     // avisa que estamos
         DBOX(msg,,,,NAO_APAGA,"AGUARDE!")                   // trabalhando...
         CLOSE ALL                                           // fecha todos os arquivos abertos
         dbf=drvdbf+sistema[op_sis,O_ARQUI]+".dbf"           // nome do arquivo para adaptar
         IF FILE(drvdbf+"temp9.dbf")                         // se o backup existir
            ERASE &drvdbf.temp9.dbf                          // vamos elimina-lo
         ENDI
         RENAME (dbf) TO &drvdbf.temp9.dbf                       // troca o nome do DBF para temp9
         stru=LEFT(sistema[op_sis,O_ARQUI],3)+"_estr"        // nome do prg da nova estrutura
         &stru.()                                            // cria nova estrutura
         SELE A
         USE (dbf) ALIAS ATUAL                               // abre o novo DBF
         SELE B
         USE &drvdbf.temp9 ALIAS VELHO                       // abre o dbf antigo
         DO WHILE !EOF()                                     // processaremos todos os registros...
            SELE ATUAL
            APPEND BLANK                                     // cria um novo registro
            FOR i=1 TO qtcps                                 // coloca em cada campo
               msg=estru_nov[i,1]                            // do novo registro, o conteudo
               IF !EMPTY(cps_[i])                            // escolhido do DBF anterior
                  REPL &msg. WITH VELHO->(&(cps_[i]))
               ENDI
            NEXT
            IF VELHO->(DELE())                               // se o reg esta macado para
               DELE                                          // exclusao vamos marcar no
            ENDI                                             // novo tambem
            SELE VELHO                                       // proximo...
            SKIP
         ENDD
         op_a=0
      ELSEIF op_=2 .OR. op_=0                                // quer redigitar os conteudos
         op_a=1
      ELSE                                                   // cancelou a operacao
         RETU .f.
      ENDI
   ENDI
ENDD
RESTSCREEN(0,0,MAXROW(),79,v1)                               // coloca cabecalho e pano de fundo
DBOX(msg_veri,,,,NAO_APAGA,"AGUARDE!")                       // avisa que estamos trabalhando...
CLOSE ALL                                                    // fecha todos os arquivos e
RETU .t.                                                     // prossegue conversao de outros arquivos

FUNC TRATADIR(drv_)                                          // trata diretorio informado
drv_=ALLTRIM(drv_)                                           // tira espacos
drv_=IF(RIGHT(drv_,1)!="\".AND.;                             // diretorio tem que
       LEN(drv_)>0,drv_+"\",drv_)                            // terminar com barra (\)
RETU drv_

FUNC DRVEXISTE(drv_)                                         // testa se diretorio existe
LOCAL drv_atual:="\"+CURDIR(),x
drv_=ALLTRIM(drv_)                                           // tira espacos
drv_=IF(RIGHT(drv_,1)!="\".AND.;
     LEN(drv_)>0,drv_+"\",drv_)                              // terminar com barra (\)
drv_=LEFT(drv_,LEN(drv_)-1)
IF !CHDIR(drv_) .AND. LEN(drv_)>2                            // se diretorio nao existe,
   ALERTA(2)                                                 // beep, beep e
   op_=DBOX("Diret¢rio ilegal!",,,,,"ATEN€ŽO!")              // avisa
   RETU .f.
ELSE                                                         // ok, diretorio existe,
   CHDIR(drv_atual)                                          // posiciona no diretorio anterior
ENDI
RETU .t.

PROC VE1_CAMPOS                                               // mostra os campos da
LOCAL ve_op:=""                                              // estrutura anterior e
FOR i=1 TO LEN(estru_vel)                                    // permite a captura do
   ve_op+="|"+PADR(estru_vel[i,1],12)+;                      // nome do campo para
          " "+estru_vel[i,2]+;                               // dentro da expressao
          LPAD(STR(estru_vel[i,3]),4)+;                      // que esta sendo informada
          LPAD(STR(estru_vel[i,4]),3)
NEXT
op_campo=DBOX(SUBS(ve_op,2),,50,E_MENU,,"CAMPOS DA ESTRUTURA|ANTERIOR|Nome         T Tam CD")
IF op_campo>0
   KEYB ALLTRIM(estru_vel[op_campo,1])
ENDI
RETU

PROC HELP1                                                    // ajuda (F1)
LOCAL tela_, cor_, t, estr_db, tec_f10, txt:=ARRAY(6)
SETKEY(K_F1,NIL)                                             // evita recursividade
tec_f10=SETKEY(K_F10,NIL)                                    // desabilita tecla F10
tela_=SAVESCREEN(0,0,MAXROW(),79)                            // salva a tela por baixo e
cor_=SETCOLOR(drvcorenf)                                     // o esquema de cor vigente
DO CASE
   CASE cod_sos=1
      txt={;
            "A coluna ESTRUTURA deste menu mostra os campos atuais do",;
            "arquivo de  dados que necessitam ser adaptados. Na colu-",;
            "na PREENCHER COM: aparecem as sugest”es para serem colo-",;
            "cadas dentro de cada campo.     Caso queira mudar alguma",;
            "sugest„o  pressione ENTER  sobre o campo  desejado  caso",;
            "contrario, tecle ESC para prosseguir a opera‡„o.        ";
          }
   CASE cod_sos=2
      txt={;
            "     Informe um novo conte£do para colocar no campo,  em",;
            "todos os registros do arquivo.  Pode ser utilizada qual-",;
            "quer express„o em CA-Clipper, nomes de campos, etc, des-",;
            "de que tenham o mesmo tipo do campo a modificar. A tecla",;
            "F10 pode ser utilizada para capturar conte£dos de campos",;
            "da estrutura anterior deste arquivo DBF.";
          }
   CASE cod_sos=3
      txt={;
            "     Selecione a op‡„o PROSSEGUIR para iniciar o proces-",;
            "so de convers„o do arquivo  em  destaque no t¡tulo  dete",;
            "menu (todos os registros do arquivo ser„o atingidos). Se",;
            "desejar corrigir mais alguma informa‡„o, selecione REFA-",;
            "ZER CONTEUDO ou tecle ESC.   A op‡„o CANCELAR A OPERA€ŽO",;
            "serve para retornar ao DOS.";
          }
   CASE cod_sos=4
      txt={;
            "     Informe os diret¢rios onde residem os diversos  ar-",;
            "quivos (DBF, NTX e senhas) da aplica‡„o que ir  sofrer a",;
            "adapta‡„o.    Os nomes dos diret¢rios informados dever„o",;
            "terminar com o caracter '\'.   Informados os diret¢rios,",;
            "selecione a op‡„o 'Prosseguir` para  este programa  ini-",;
            "ciar as adapta‡”es necess rias.";
          }
ENDC
SETCOLOR("GR+"+SUBS(drvcorenf,AT("/",drvcorenf)))            // prepara esquema de cor
CAIXA(mold,2,10,9,69)                                        // monta janela
@ 9,37 SAY " ESC "                                           // mostra tecla de finalizacao
SETCOLOR(drvcorenf)
FOR t=1 TO 6                                                 // apresenta msg na janela
   @ 2+t,12 SAY txt[t]
NEXT
INKEY(0)                                                     // espera uma tecla
SETCOLOR(cor_)                                               // retorna a cor original
RESTSCREEN(0,0,MAXROW(),79,tela_)
SETKEY(K_F10,tec_f10)                                        // habilita tecla F10
SET KEY K_F1 TO help1                                         // reprograma o help
RETU

* \\ Final de SFI_ADAP.PRG
