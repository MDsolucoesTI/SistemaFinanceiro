/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFIN.PRG
 \ Data....: 19-08-96
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Gerenciador geral
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "sfin.ch"      // inicializa constantes manifestas

/*
   Funcoes chamadas dentro de macros
*/

REQUEST DESCEND, MTAB, VDV2, VCGC, VUF, EXT, NMES, LTOC

#include "SFI_PUBL.ch"  // contem variaveis publicas

V0=SAVESCREEN(0,0,MAXROW(),79)
CLEA SCREEN

#ifdef COM_TUTOR
   PARAM arq_mac, acao_                                    // recebe parametros
   acao_mac="D"                                            // inicializa flag
   IF !EMPT(arq_mac) .AND. !EMPT(acao_)                    // passou os dois paramentros
      acao_=UPPER(acao_)                                   // acao em maiusculo
      IF SUBS(acao_,2,1)$'LGCA'.AND.LEN(acao_)=2           // acao e' valida?
         acao_=SUBS(acao_,2,1)                             // separa so a letra
         IF acao_ $ "LCA" .AND. !FILE(arq_mac)             // leitura, se o arq
            ALERTA(2)                                      // nao existir vamos
            ? "Arquivo "+arq_mac+" n„o encontrado!"        // avisar e
            RETU                                           // voltar para os DOS
         ELSE
            IF acao_="G"                                   // gravacao de tutorial
               IF FILE(arq_mac)                            // se o arq existir
                  ALERTA(2)                                // pergunta se pode
                  x="N"                                    // mata-lo...
                  @ 10,20 SAY "Arquivo "+arq_mac+" j  existe sobrepor?" GET x PICT "!"
                  READ
                  CLEA SCREEN
                  IF LASTKEY()=K_ESC .OR. x!="S"           // nao confirmou...
                     ? "Execu‡„o interrompida!"            // da mensagem e
                     RETU                                  // retorna para o DOS
                  ENDI
                  ERASE (arq_mac)                          // mata arq antigo
               ENDI
               handle_mac=FCREATE(arq_mac)                 // cria um novo arq
            ELSE
               handle_mac=FOPEN(arq_mac,2)                 // abre arq existente
            ENDI
            IF handle_mac=-1                               // se deu erro na abertura
               ? "N„o foi poss¡vel utilizar "+arq_mac      // avisa e
               RETU                                        // retorna
            ENDI
            fat_mac=5                                      // fator de tempo default
            acao_mac=acao_                                 // seta a acao da macro
         END IF
      END IF
   ENDI
#endi

NAOPISCA()                         // habilita 256 cores (ega/vga)

/*
   rotina utilizando funcoes em assembly  para pegar o nome do programa
   que e  colocado pelo DOS no PSP (Program Segment Prefix) do programa
   que esta  sendo executado. O segmento do ambiente esta  no  endereco
   44/45 do segmento do PSP
*/
VAL_AX("6200")                     // funcao 62h retorna segmento do PSP em BX
CALLINT("21")                      // executa interrupt 21
x=VAL_BX()                         // pega o segmento do PSP
Sg=PEEK(x,44)+PEEK(x,45)*256       // calcula endereco do segmento de ambiente

/*
   Agora, procura no segmento de ambiente, por dois bytes ZERO seguidos.
   O nome do programa comeca 2 bytes apos os ZEROs
*/
x=0
DO WHIL .t.
   IF PEEK(Sg,x)=0                 // este e o primeiro ZERO
      IF PEEK(Sg,x+1)=0            // se o proximo tambem for,
         x+=2                      // entao pula ambos
         EXIT                      // e sai
      ENDI
   ENDI
   x++                             // continua procurando
ENDD
direxe=""
IF PEEK(Sg,x)=1                    // se este byte = 1, entao
   x+=2                            // o nome comeca aqui e vai
   DO WHIL PEEK(Sg,x)>0            // at‚ encontrar outro 0
      direxe+=CHR(PEEK(Sg,x))      // pega mais uma letra do nome
      x++
   ENDD
ENDI
direxe=UPPER(LEFT(direxe,RAT("\",direxe)))
arq_sos=direxe+"SFIN.SOS"          // nome do arquivo de ajuda
SET CENTURY ON                     // datas com informa‡„o do s‚culo DD/MM/AAAA
SETCANCEL(.f.)                     // desativa ALT-C/BREAK
SET DATE BRIT                      // datas no formato 'britasileiro`
SET EXAC OFF                       // comparacoes parciais habilitadas
SET SCOREBOARD OFF                 // habilita uso da linha 0
SET WRAP ON                        // habilita rolagem de menus
SET KEY K_ALT_F2  TO doscom        // ALT-F2 ativa DOS-SHELL
SETKEY(K_INS,{||;                  // muda tamanho do cursor quando inserindo
              IF(READINSERT(),SETCURSOR(1),SETCURSOR(3)),;
              READINSERT(!READINSERT());
             };
)


/*
   inicializa variaveis publicas
*/
msg:=cpord:=criterio:=chv_rela:=chv_1:=chv_2:=vr_memo := ""
op_sis:=cod_sos:=nucop:=op_posi:=op_menu :=1
nss=13
exrot:=AFILL(ARRAY(nss),""); usuario=""
datac=DATE()
nao_mostra:=l_s:=c_s:=c_i:=l_i := 0
tem_borda:=drvexcl:=drvvisivel := .t.
v_out:=gr_rela:=ve_outros:=cn:=fgrep:=drvmouse :=.f.
tem_t:=fgconf:=drvconf:=brw:=drvincl :=.f.
gcr=CHR(17)+CHR(217); nivelop=3
sgr_ok=SGRAFICO(ATIVO)                      // SGR esta residente?
drvcara=CHR(32); mold="ÕÍ¸³¾ÍÔ³ÆÍµ"
drvmenucen=.f.; drvfonte=18
drvporta="LPT1"
nemp="Denny Paulista Azevedo Filho"
nsis="Sistema Financeiro"

#ifdef COM_MOUSE
   drvmouse=(MOUSE()>0)                     // verifica e inicializa mouse

   #ifdef COM_TUTOR
      IF acao_mac!="D"
         drvmouse=.f.
      ENDI
   #endi

   drvratH=8; drvratV=16                    // default da sensibilidade do mouse
   tpo_mouse=0
#endi

#ifdef COM_REDE
   ms_uso="Arquivo sendo acessado|COM EXCLUSIVIDADE"
#endi

#ifdef COM_LOCK
   pr_ok=__PPRJ(arq_sos,"ùÿáõæâñúâüååúùáôáàÿþ")
   IF LEN(pr_ok)>0
      CLEAR
      ? pr_ok
      RETU
   ENDI
#endi

arqgeral="SFI"

#ifdef COM_REDE

   #undef COM_PROTECAO

   drvtempo=25
   ide_maq=RIGHT(ALLTRIM(NETNAME()),4)      // tenta pegar nome da estacao
   IF EMPTY(ide_maq)                        // se netname() retornou nulo,
      ide_maq=LEFT(GETENV("ESTACAO"),4)     // tenta variavel de ambiente ESTACAO
   ENDI

   /*
      Se rede, e se NETNAME() do Clipper ou ESTACAO retornam "", pede ao usuario
      a identificacao da estacao para gravar arquivos de configuracoes
      especificos para cada usuario da rede
   */
   IF EMPTY(ide_maq)                       // CA-Clipper nao reconheceu nome da estacao
      cod_sos=49                           // nem existe variavel ambiental,
      msgt="IDENTIFICA€ŽO DA ESTA€ŽO"      // entao, vamos solicitar ao usuario
      SET KEY K_F1 TO                      // desativa help
      ide_maq=DBOX("Nome da esta‡„o",,,,,msgt,SPAC(4),"@!",,"W+/N")
      SET KEY K_F1 TO help                 // habilita F1 (help)
      IF LASTKEY()=K_ESC .OR.;             // desistiu...
         EMPTY(ide_maq)                    // ou nao informou
         RESTSCREEN(0,0,MAXROW(),79,v0)    // restaura tela
         SETPOS(MAXROW()-1,1)              // cursor na penultima linha, coluna 1
         RETU                              // e volta ao DOS
      ENDI
   ENDI
   ide_maq="_"+ALLTRIM(ide_maq)
#else
   ide_maq="_temp"                         // nome do arquivo de configuracoes
#endi

ntxpw=direxe+arqgeral+"PW"
dbfpw=ntxpw+".SYS"                         // nomes dos arquivos de senhas
arqconf=direxe+arqgeral+;                  // nome do arquivo de configuracoes
        ide_maq+".sys"
IF FILE(arqconf)
   REST FROM (arqconf) ADDI                // restaura configuracoes gravadas

   #ifdef COM_MOUSE
      IF drvmouse
         drvmouse=(MOUSE()>0)              // verifica e inicializa mouse
         MOUSERAT(drvratH,drvratV)         // ajusta sensibilidade do mouse
      ENDI
   #else
      drvmouse=.f.
   #endi

ELSE

   /*
      cria variaveis default de cores, codigos de impressao, etc...
   */
   drvmarca := "GSX 230 Citizen"              // nome da configuracao/marca impressora
   drvprn =1                                  // configuracao atual
   drvpadrao="4"                              // padrao da impressora
   drvtapg="CHR(27)+'C'+CHR(NNN)"             // tamanho da pagina
   drvpcom="CHR(15)"                          // ativa comprimido (17,5 cpp)
   drvtcom="CHR(18)"                          // desativa comprimido (17,5 cpp)
   drvpc20="CHR(27)+'M'+CHR(15)"              // ativa comprimido (20 cpp)
   drvtc20="CHR(27)+'P'"                      // desativa comprimido (20 cpp)
   drvpeli="CHR(27)+'M'"                      // ativa elite
   drvteli="CHR(27)+'P'"                      // desativa elite
   drvpenf="CHR(27)+'E'"                      // ativa enfatizado
   drvtenf="CHR(27)+'F'"                      // desativa enfatizado
   drvpexp="CHR(27)+'W'+CHR(1)"               // ativa expansao
   drvtexp="CHR(27)+'W'+CHR(0)"               // desativa expansao
   drvpde8="CHR(27)+'0'"                      // ativa 8 lpp
   drvtde8="CHR(27)+'2'"                      // desativa 8 lpp
   drvland=""                                 // ativa landscape (paisagem)
   drvport=""                                 // ativa portrait (retrato)
   drvsom=.f.                                 // tipo de saida/efeitos sonoro
   drvautohelp=.f.                            // ajuda automatica em campos
   drvdbf:=drvntx:=drverr := PADR(QUALDIR(),23)
                                              // diretorio dos dbf's, ntx's e erros.dbf
   drvcorpad="N/N*"   ; drvcorbox="W+/BG"     // cores default
   drvcormsg="W+/B"   ; drvcorenf="W+/R"
   drvcorget="W+/N"   ; drvcortel="W+/N"
   drvcorhlp="W+/BG"
   drvtitpad="GR+/N*" ; drvtitbox="GR+/BG"    // cores dos titulos default
   drvtitmsg="GR+/B"  ; drvtitenf="GR+/R"
   drvtitget="GR+/N"  ; drvtittel="GR+/N"
   drvtithlp="GR+/BG"
   CBC1(.f.)
   ALERTA()
   cod_sos=2
   IF !PEGADIR(.t.)                        // se nao informou diretorios de trabalho
      RESTSCREEN(0,0,MAXROW(),79,v0)       // restaura tela
      SETPOS(MAXROW()-1,1)                 // cursor na penultima linha, coluna 1
      RETU                                 // de volta ao DOS
   ENDI

   /*
      cria arquivo de senha e o inicializa com o primeiro usuario
   */
   IF !FILE(dbfpw)                          // nao encontrou arquivo de senhas,
      DBCREATE(dbfpw,{;                     // entao, cria estrutura
                      {"pass"       ,"C", 6,0},;
                      {"nome"       ,"C",15,0},;
                      {"nace"       ,"C", 1,0},;
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
                     };
      )

      #ifdef COM_REDE
         USEARQ(dbfpw,.t.,20,1,.f.)         // tenta abrir senhas, exclusivo
      #else
         USE (dbfpw)                        // abre arquivo de senhas
      #endi

      INDE ON pass TO (ntxpw)               // indexa pela password
      APPE BLAN                             // credencia usuario ficticio (1o. acesso)
      senha=PWORD(arqgeral)                 // com senha = tres primeiras letras
      REPL nome WITH ENCRIPT("Usu rio        "),;
           pass WITH senha, nace WITH ENCRIPT("3")
      USE
   ENDI
ENDI

#ifdef COM_TUTOR
   IF acao_mac!="D"
      drvmouse=.f.
   ENDI
#endi

arq_prn=drverr+"PRINTERS.DBF"                    // nome dbf de "drivers" da prn
IF !FILE(arq_prn)                                // se o arquivo de "drivers"
   DBCREATE(arq_prn,{;                           // de impressoras nao existir
                     {"marca" ,"C",15,0},;        // entao vamos cria-lo
                     {"porta" ,"C", 4,0},;
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
                    };
   )

   #ifdef COM_REDE
      USEARQ(arq_prn,.t.,20,1,.f.)          // tenta abrir configuracoes, exclusivo
   #else
      USE (arq_prn)                         // abre arquivo de configuracoes
   #endi

   APPE BLAN                                // inclui uma configuracao
   REPL marca  WITH drvmarca,;              // marca da impressora
        porta  WITH drvporta,;              // porta de saida
        padrao WITH drvpadrao,;             // padrao da impressora
        tapg   WITH drvtapg,;               // tamanho da pagina
        pcom   WITH drvpcom,;               // ativa comprimido (17,5 cpp)
        tcom   WITH drvtcom,;               // desativa comprimido (17,5 cpp)
        pc20   WITH drvpc20,;               // ativa comprimido (20 cpp)
        tc20   WITH drvtc20,;               // desativa comprimido (20 cpp)
        peli   WITH drvpeli,;               // ativa elite
        teli   WITH drvteli,;               // desativa elite
        penf   WITH drvpenf,;               // ativa enfatizado
        tenf   WITH drvtenf,;               // desativa enfatizado
        pexp   WITH drvpexp,;               // ativa expansao
        texp   WITH drvtexp,;               // desativa expansao
        pde8   WITH drvpde8,;               // ativa 8 lpp
        tde8   WITH drvtde8,;               // desativa 8 lpp
        land   WITH drvland,;               // ativa landscape
        port   WITH drvport                 // ativa portrait
   USE
ENDI
MUDAFONTE(drvfonte)                         // troca a fonte de caracteres
corcampo=drvtittel                          // cor "unselected"
SETCOLOR(drvcorpad+","+drvcorget+",,,"+corcampo)
SET(_SET_DELETED,!drvvisivel)               // visibilidade dos reg excluidos
CBC1(.f.)

/*
   se informado drive A para criar arquivo, previne preparo do disquete
*/
IF ASC(drvdbf)=65.OR.ASC(drvntx)=65         // informou drive A
   ALERTA()
   cod_sos=1
   op_a=DBOX("Disco pronto|Cancelar a opera‡„o",,,E_MENU,,"DISCO DE DADOS EM "+LEFT(drvdbf,1))
   IF op_a!=1
      RESTSCREEN(0,0,MAXROW(),79,v0)        // restaura tela
      SETPOS(MAXROW()-1,1)                  // cursor na penultima linha, coluna 1
      RETU
   ENDI
ENDI
AFILL(sistema:=ARRAY(nss+1),{})             // enche sistema[] com vetores nulos
SFI_ATRI()                                  // enche sistema[] com atributos dos arquivos
SFI_ATR1()

/*
   verifica qual subscricao do vetor SISTEMA corresponde ao arquivo
   aberto na area selecionada
*/
qualsis={|db_f|db_:=db_f,ASCAN(sistema,{|si|si[O_ARQUI]==db_})}

#ifdef COM_PROTECAO

   /*
      protege arquivo de dados contra acesso dBase e muda para "read-only"
      vamos comentar este "code block" ...
   */
   protdbf={|fg|pt:=fg,;                                   // torna a flag visivel no proximo "code block"
             tel_p:=SAVESCREEN(0,0,MAXROW(),79),;          // salva a tela
             DBOX("Um momento!",,,,NAO_APAGA),;            // mensagem ao usuario
             AEVAL(sistema,{|sis|;                         // executa o "code block" para cada
                             EDBF(drvdbf+;                 // um dos arquivos do vetor sistema
                                  sis[O_ARQUI],pt);        // (se pt, desprotege; senao, protege)
                           };
             ),;
             RESTSCREEN(0,0,MAXROW(),79,tel_p);            // restaura a tela
           }
#endi

IF !FILE(dbfpw)                                            // se nao existir arquivo de
   ALERTA()                                                // senhas, avisa
   DBOX("Arquivo de senhas ausente!",,,2)
   RESTSCREEN(0,0,MAXROW(),79,v0)                          // restaura a tela
   SETPOS(MAXROW()-1,1)                                    // cursor na penultima linha, coluna 1
   RETU                                                    // retorna ao DOS
ENDI

#ifdef COM_REDE
   IF ! USEARQ(dbfpw,.f.,20,1,.f.)                         // falhou abertura modo compartilhado,
      RESTSCREEN(0,0,MAXROW(),79,v0)                       // restaura tela
      SETPOS(MAXROW()-1,1)                                 // cursor na penultima linha, coluna 1
      RETU                                                 // retorna ao DOS
   ENDI
#else
   EDBF(dbfpw,.t.)                                         // desprotege arquivo de
   USE (dbfpw)                                             // senhas e o utiliza
#endi

IF !FILE(ntxpw+".ntx")                                     // se nao ha indice,
   INDE ON pass TO (ntxpw)                                 // cria o arquivo indice
ENDI
SET INDE TO (ntxpw)
IF ASC(nace)>48 .AND. ASC(nace)<52                         // previne erro

   #ifdef COM_REDE
      IF !BLOARQ(3,.5)                                     // se nao conseguiu bloquear o arquivo,
         RESTSCREEN(0,0,MAXROW(),79,v0)                    // restaura tela
         SETPOS(MAXROW()-1,1)                              // cursor na penultima linha, coluna 1
         RETU                                              // retorna ao DOS
      ENDI
   #endi

   REPL ALL nace WITH ENCRIPT(nace),;                      // manipulacao das senhas
            nome WITH ENCRIPT(nome)                        // criptografando o nivel e nome

   #ifdef COM_REDE
      UNLOCK                                               // libera arquivo
   #endi

ENDI
cod_sos=15
COLORSELECT(COR_GET)
v1=SAVESCREEN(0,0,MAXROW(),79)
CAIXA(mold,10,22,14,58,440)
@ 11,30 SAY "INFORME A SUA SENHA"                          // monta janela para
@ 12,35 SAY "Þ      Ý"                                     // solicitar a entrada
@ 13,26 SAY "ESC para recome‡ar/finalizar"                 // da senha de acesso
cp_=1
DO WHIL .t.
   COLORSELECT(COR_GET)
   senha=PADR(PWORD(12,36),6)                              // recebe a senha do usuario
   COLORSELECT(COR_PADRAO)
   SEEK senha                                              // ve se esta' credenciado
   IF FOUND()                                              // OK!
      usuario=TRIM(DECRIPT(nome))                          // nome do usuario
      senhatu=senha                                        // sua senha
      nivelop=VAL(DECRIPT(nace))                           // seu nivel
      FOR t=1 TO nss                                       // exrot[] contera' as
         msg=sistema[t,O_ARQUI]                            // rotinas nao acessadas
         exrot[t]=ex&msg.                                  // de cada subsistema
      NEXT
      IF nivelop>0.AND.nivelop<4                           // de 1 a 3...
         DBOX("Bom trabalho, "+usuario,13,45,2)            // boas vindas!
         EXIT                                              // use e abuse...
      ENDI
   ELSE
      IF cp_<2 .AND. !EMPTY(senha)                         // epa! senha invalida
         cp_++                                             // vamos dar outra chance
         ALERTA()                                          // estamos avisando!
         DBOX("Senha inv lida!",,,1)
         COLORSELECT(COR_GET)
         @ 12,36 SAY SPAC(6)
      ELSE                                                 // errou duas vezes!
         IF !EMPTY(senha)                                    // se informou senha errada
            ALERTA()                                         // pode ser um E.T.
            DBOX("Usu rio n„o autorizado!",,,2)
         ENDI

         #ifndef COM_REDE
            EDBF(dbfpw,.f.)                                // protege o arquivo de senhas
         #endi

         #ifdef COM_PROTECAO
            EVAL(protdbf,.f.)                              // protege DBF
         #endi

         RESTSCREEN(0,0,MAXROW(),79,v0)                    // restaura tela,
         SETPOS(MAXROW()-1,1)                              // cursor na penultima linha, coluna 1
         MUDAFONTE(0)                                      // retorna com a fonte normal
         RETU                                              // e tchau!
      ENDI
   ENDI
ENDD
RESTSCREEN(0,0,MAXROW(),79,v1)                             // restaura tela
USE                                                        // fecha o arquivo de senhas

#ifdef COM_PROTECAO
   EVAL(protdbf,.t.)                                       // desprotege DBFs
#endi

msg_auto="Opera‡„o n„o autorizada, "+usuario
IF !CRIADBF()                                              // se DBF nao criado,

   #ifdef COM_PROTECAO
      EVAL(protdbf,.f.)                                      // protege DBF
   #endi

   RESTSCREEN(0,0,MAXROW(),79,v0)                          // restaura tela
   SETPOS(MAXROW()-1,1)                                    // cursor na penultima linha, coluna 1
   RETU                                                    // volta ao DOS
ENDI
IF ! sgr_ok                                                // se o SGR nao esta residente
   ALERTA(2)                                               // vamos avisar
   msg_sgr="SGR (Servidor Gr fico Residente) n„o est  residente!"
   DBOX(msg_sgr)
ENDI
SET CONF (drvconf)                                         // ajusta SET CONFIRM
cod_sos=1
ALERTA(1)
msg="Atualize a data de hoje"
datac=DBOX(msg,,,,,"ATEN€ŽO!",datac,"99/99/99")            // confirma a data
IF UPDATED()                                               // se modificou sugestao,
   DOSDATA(DTOC(datac))                                    // vamos atualizar o DOS
ENDI
dbfparam=drvdbf+"PARAMET"
SELE A

#ifdef COM_REDE
   USEARQ(dbfparam,.t.,,,.f.)
#else
   USE (dbfparam)
#endi

//Do Chama

/*
   cria variaveis de memoria publicas identicas as de arquivo,
   para serem usadas por toda a aplicacao
*/
FOR i=1 TO FCOU()
   msg=FIEL(i)
   M->&msg.=&msg.
NEXT
USE
CBC1(.t.)
opc_01=1
v01=SAVESCREEN(0,0,MAXROW(),79)
Set Key K_ALT_X to Sair
DO WHIL opc_01!=0
   cod_sos=3
   Set Key K_F2 to MudaOp
   RESTSCREEN(0,0,MAXROW(),79,v01)
   Infosis("[F1] Help, [F2] Muda Operador, [F5] Calendario, [F6] Calculadora, [ALT+X] Sair")
   menu01="Arquivos|"+;
          "Opera‡”es|"+;
          "Consultas|"+;
          "Relat¢rios|"+;
          "Utilit rios"
   opc_01=DBOX(menu01,0,,E_POPMENU,NAO_APAGA,,,,opc_01)
   Set Key K_F2 to
   BEGIN SEQUENCE
      DO CASE
         CASE opc_01=0      // retornar ao DOS
            ALERTA()
            msgt="ENCERRAMENTO"
            msg ="Finalizar opera‡”es|N„o finalizar"
            cod_sos=1
            op_=DBOX(msg,,,E_MENU,,msgt,,,1)
            IF op_=1
               MUDAFONTE(0)
            ELSE
               opc_01=1
            ENDI

         CASE opc_01=1     // arquivos
            opc_02=1
            v02=SAVESCREEN(0,0,MAXROW(),79)
            DO WHIL opc_02!=0
               cod_sos=60
               RESTSCREEN(0,0,MAXROW(),79,v02)
               menu02="Fornecedores   |"+;
                      "Clientes       |"+;
                      "Caixa - Bancos |"+;
                      "Financeiros    "
               ROLAPOP(1)
               opc_02=DBOX(menu02,1,2,E_MENU,NAO_APAGA,,,,opc_02)
               ROLAPOP()
               DO CASE
                  CASE opc_02=1     // fornecedores
                     FORNEC(3,10)

                  CASE opc_02=2     // clientes
                     CLIENTES(3,10)

                  CASE opc_02=3     // caixa - bancos
                     BANCOS(3,10)

                  CASE opc_02=4     // financeiros
                     IF nivelop < 2     // usuario pode acessar esta opcap?...
                        ALERTA()
                        DBOX(msg_auto,,,3)
                        LOOP
                     ENDI
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="A‡„o Financeira      |"+;
                               "Hist¢rico Padr„o     |"+;
                               "Centro de Custo      |"+;
                               "Tipos de Cr‚dito     |"+;
                               "Formatos dos Cheques "
                        opc_03=DBOX(menu03,3,10,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // a‡„o financeira
                              CONTAS(5,18)

                           CASE opc_03=2     // hist¢rico padr„o
                              HISTO(5,18)

                           CASE opc_03=3     // centro de custo
                              CUSTO(5,18)

                           CASE opc_03=4     // tipos de cr‚dito
                              CREDITO(5,18)

                           CASE opc_03=5     // formatos dos cheques
                              TICHEQUE(5,18)

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

               ENDC
               CLEA GETS
               CLOS ALL
            ENDD

         CASE opc_01=2     // opera‡”es
            opc_02=1
            v02=SAVESCREEN(0,0,MAXROW(),79)
            DO WHIL opc_02!=0
               cod_sos=61
               RESTSCREEN(0,0,MAXROW(),79,v02)
               menu02="Movimentos Financeiros   |"+;
                      "Fechamento Financeiro     |"+;
                      "Contas a Pagar           |"+;
                      "Gera Parcelas a Pagar     |"+;
                      "Baixa de Contas a Pagar   |"+;
                      "Estorno Contas a Pagar    |"+;
                      "Contas a Receber         |"+;
                      "Gera Parcelas a Receber   |"+;
                      "Baixa Contas a Receber    |"+;
                      "Recibo Cliente|"+;
                      "Estorno Contas a Receber  |"+;
                      "Gerar Posi‡„o Financeira"
               ROLAPOP(1)
               opc_02=DBOX(menu02,1,12,E_MENU,NAO_APAGA,,,,opc_02)
               ROLAPOP()
               DO CASE
                  CASE opc_02=1     // movimentos financeiros
                     MOVIM(3,20)

                  CASE opc_02=2     // fechamento financeiro
                     SFI_P002(3,20)

                  CASE opc_02=3     // contas a pagar
                     PAGAR(3,20)

                  CASE opc_02=4     // gera parcelas a pagar
                     SFI_P010(3,20)

                  CASE opc_02=5     // baixa de contas a pagar
                     SFI_P001(3,20)

                  CASE opc_02=6     // estorno contas a pagar
                     SFI_P003(3,20)

                  CASE opc_02=7     // contas a receber
                     RECEBER(3,20)

                  CASE opc_02=8     // gera parcelas a receber
                     SFI_P012(3,20)

                  CASE opc_02=9     // baixa contas a receber
                     SFI_P004(3,20)

                  CASE opc_02=10     // recibo cliente
                     SFI_R009(3,20)

                  CASE opc_02=11     // estorno contas a receber
                     SFI_P005(3,20)

                  CASE opc_02=12     // gerar posi‡„o financeira
                     SFI_P019(3,20)

               ENDC
               CLEA GETS
               CLOS ALL
            ENDD

         CASE opc_01=3     // consultas
            opc_02=1
            v02=SAVESCREEN(0,0,MAXROW(),79)
            DO WHIL opc_02!=0
               cod_sos=4
               RESTSCREEN(0,0,MAXROW(),79,v02)
               menu02="Contas a Pagar         |"+;
                      "Contas a Receber       |"+;
                      "D¡vida Cliente|"+;
                      "Movimentos Financeiros  "
               ROLAPOP(1)
               opc_02=DBOX(menu02,1,23,E_MENU,NAO_APAGA,,,,opc_02)
               ROLAPOP()
               DO CASE
                  CASE opc_02=1     // contas a pagar
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="Valores em Aberto|"+;
                               "Valores Pagos"
                        opc_03=DBOX(menu03,3,31,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // valores em aberto
                              CONPAGAR(5,39)

                           CASE opc_03=2     // valores pagos
                              CONABER(5,39)

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

                  CASE opc_02=2     // contas a receber
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="Valores em Aberto|"+;
                               "Valores Pagos"
                        opc_03=DBOX(menu03,3,31,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // valores em aberto
                              CONRECEB(5,39)

                           CASE opc_03=2     // valores pagos
                              RECPAG(5,39)

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

                  CASE opc_02=3     // d¡vida cliente
                     DIVCLI(3,31)

                  CASE opc_02=4     // movimentos financeiros
                     CONMOVIM(3,31)

               ENDC
               CLEA GETS
               CLOS ALL
            ENDD

         CASE opc_01=4     // relat¢rios
            opc_02=1
            v02=SAVESCREEN(0,0,MAXROW(),79)
            DO WHIL opc_02!=0
               cod_sos=4
               RESTSCREEN(0,0,MAXROW(),79,v02)
               menu02="Listagem dos Clientes|"+;
                      "Contas a Receber         |"+;
                      "Mala Direta - Clientes    |"+;
                      "Listagem de Fornecedores  |"+;
                      "Contas a Pagar           |"+;
                      "Mala Direta - Fornecedor  |"+;
                      "Emiss„o de Cheques       |"+;
                      "Movimentos Financeiros|"+;
                      "Posi‡„o Banc ria|"+;
                      "Posi‡„o Financeira       "
               ROLAPOP(1)
               opc_02=DBOX(menu02,1,34,E_MENU,NAO_APAGA,,,,opc_02)
               ROLAPOP()
               DO CASE
                  CASE opc_02=1     // listagem dos clientes
                     SFI_R001(3,42)

                  CASE opc_02=2     // contas a receber
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="Valores a Receber|"+;
                               "Valores Recebidos"
                        opc_03=DBOX(menu03,3,42,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // valores a receber
                              SFI_R004(5,50)

                           CASE opc_03=2     // valores recebidos
                              SFI_R008(5,50)

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

                  CASE opc_02=3     // mala direta - clientes
                     SFI_E001(3,42)

                  CASE opc_02=4     // listagem de fornecedores
                     SFI_R005(3,42)

                  CASE opc_02=5     // contas a pagar
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="Valores em Aberto|"+;
                               "Valores Pagos"
                        opc_03=DBOX(menu03,3,42,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // valores em aberto
                              SFI_R003(5,50)

                           CASE opc_03=2     // valores pagos
                              SFI_R007(5,50)

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

                  CASE opc_02=6     // mala direta - fornecedor
                     SFI_E002(3,42)

                  CASE opc_02=7     // emiss„o de cheques
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="Registro de Cheques  |"+;
                               "Impress„o de Cheques  |"+;
                               "Contra Cheques"
                        opc_03=DBOX(menu03,3,42,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // registro de cheques
                              CHEQUES(5,50)

                           CASE opc_03=2     // impress„o de cheques
                              SFI_R010(5,50)

                           CASE opc_03=3     // contra cheques
                              SFI_R011(5,50)

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

                  CASE opc_02=8     // movimentos financeiros
                     SFI_R002(3,42)

                  CASE opc_02=9     // posi‡„o banc ria
                     SFI_R006(3,42)

                  CASE opc_02=10     // posi‡„o financeira
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=4
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="Relat¢rio|"+;
                               "Gr fico"
                        opc_03=DBOX(menu03,3,42,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // relat¢rio
                              SFI_R020(5,50)

                           CASE opc_03=2     // gr fico
                              IF sgr_ok
                                 SFI_G001(5,50)
                              ELSE
                                 ALERTA(2)
                                 DBOX(msg_sgr)
                              ENDI

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD

               ENDC
               CLEA GETS
               CLOS ALL
            ENDD

         CASE opc_01=5     // utilit rios
            opc_02=1
            v02=SAVESCREEN(0,0,MAXROW(),79)
            DO WHIL opc_02!=0
               op_menu=PROJECOES
               cod_sos=9
               RESTSCREEN(0,0,MAXROW(),79,v02)
               menu02="Configura‡”es do Sistema  |"+;
                      "Zera Centro de Custo|"+;
                      "Backup|"+;
                      "Restaura backup|"+;
                      "Reconstr¢i ¡ndices|"+;
                      "Elimina reg apagados|"+;
                      "Vˆ relat¢rio gravado|"+;
                      "Configura ambiente       |"+;
                      "Plano de senhas"
               ROLAPOP(1)
               opc_02=DBOX(menu02,1,46,E_MENU,NAO_APAGA,,,,opc_02)
               ROLAPOP()
               DO CASE
                  CASE opc_02=1     // configura‡”es do sistema
                     PARAMET(3,54)

                  CASE opc_02=2     // zera centro de custo
                     IF nivelop < 2     // usuario pode acessar esta opcap?...
                        ALERTA()
                        DBOX(msg_auto,,,3)
                        LOOP
                     ENDI
                     cod_sos=1
                     ZERACUST(3,54)

                  CASE opc_02=3     // backup
                     GBAK()

                  CASE opc_02=4     // restaura backup
                     RBAK()

                  CASE opc_02=5     // reconstr¢i ¡ndices
                     cod_sos=39
                     RCLA()

                  CASE opc_02=6     // elimina reg apagados
                     IF nivelop < 2     // usuario pode acessar esta opcap?...
                        ALERTA()
                        DBOX(msg_auto,,,3)
                        LOOP
                     ENDI
                     cod_sos=40
                     COMPACTA()

                  CASE opc_02=7     // vˆ relat¢rio gravado
                     VE_REL()

                  CASE opc_02=8     // configura ambiente
                     opc_03=1
                     v03=SAVESCREEN(0,0,MAXROW(),79)
                     DO WHIL opc_03!=0
                        cod_sos=41
                        RESTSCREEN(0,0,MAXROW(),79,v03)
                        menu03="ÿ Impressoraÿÿÿÿÿÿÿÿÿÿÿ|"+;
                               "ÿ Pano de fundoÿÿÿÿÿÿÿÿ|"+;
                               "ÿ Fontes de caracteresÿ|"+;
                               "ÿ Esquemas de coresÿÿÿÿ|"+;
                               IF(drvconf,"û ","ÿ ")+"Confirma em camposÿÿÿ|"+;
                               IF(drvexcl,"û ","ÿ ")+"Confirma exclus”esÿÿÿ|"+;
                               IF(drvvisivel,"û ","ÿ ")+"Excluidos vis¡veisÿÿÿ|"+;
                               IF(drvincl,"û ","ÿ ")+"Confirma inclus”esÿÿÿ|"+;
                               IF(drvsom,"û ","ÿ ")+"Efeitos sonorosÿÿÿÿÿÿ|"+;
                               IF(drvautohelp,"û ","ÿ ")+"Ajuda de campo ativaÿ|"+;
                               IF(drvmouse,"û ","ÿ ")+"Utiliza mouseÿÿÿÿÿÿÿÿ|"+;
                               "ÿ Sensibilidade mouseÿÿ"
                        opc_03=DBOX(menu03,3,54,E_MENU,NAO_APAGA,,,,opc_03)
                        DO CASE
                           CASE opc_03=1     // impressora
                              CONFPRN()

                           CASE opc_03=2     // pano de fundo
                              cod_sos=43; msg=""                      // menu de caracteres para fundo
                              FOR t=1 TO 255                          // enche msg com as opcoes
                                 IF t!=124                            // exceto o '|` que e o
                                    msg+="|"+STR(t,3)+" - "+CHR(t)    // caracter separador das
                                 ENDI                                 // opcoes da DBOX(
                              NEXT
                              t=ASC(drvcara)-IF(ASC(drvcara)>123,1,0)
                              op_x=DBOX(SUBS(msg,2),,62,E_MENU,,,,,t)
                              IF op_x!=0                              // escolhido um caracter
                                 op_x+=IF(op_x>123,1,0)               // desconta o '|`
                                 IF drvcara!=CHR(op_x)                // se caracter
                                    drvcara=CHR(op_x)                 // diferente do atual
                                    SAVE TO (arqconf) ALL LIKE drv*   // grava configuracoes,
                                    CBC1(.t.)                         // monta tela principal e
                                    v01=SAVESCREEN(0,0,MAXROW(),79)   // salva para o break
                                    BREAK                             // que foi configurado
                                 ENDI
                              ENDI

                           CASE opc_03=3     // fontes de caracteres
                              op_x=1; cod_sos=53
                              msgf=MUDAFONTE(999)
                              DO WHILE op_x!=0 .AND.LEN(msgf)>0
                                 msgf=STRTRAN(msgf,CHR(251)," ")
                                 msgf=LEFT(msgf,13*drvfonte)+CHR(251)+SUBS(msgf,13*drvfonte+2)
                                 op_x=DBOX(msgf,05,62,E_MENU,,,,,drvfonte+1)
                                 IF op_x>0
                                    drvfonte=op_x-1
                                    MUDAFONTE(drvfonte)
                                 ENDI
                              ENDD

                           CASE opc_03=4     // esquemas de cores
                              CONFCORES()

                           CASE opc_03=5     // confirma em campos
                              drvconf=!drvconf
                              SET(_SET_CONFIRM,drvconf)

                           CASE opc_03=6     // confirma exclus”es
                              drvexcl=!drvexcl

                           CASE opc_03=7     // excluidos vis¡veis
                              drvvisivel=!drvvisivel
                              SET(_SET_DELETED,!drvvisivel)

                           CASE opc_03=8     // confirma inclus”es
                              drvincl=!drvincl

                           CASE opc_03=9     // efeitos sonoros
                              drvsom=!drvsom

                           CASE opc_03=10     // ajuda de campo ativa
                              drvautohelp=!drvautohelp

                           CASE opc_03=11     // utiliza mouse
                              IF MOUSE()>0
                                 drvmouse=!drvmouse
                              ENDI

                              #ifdef COM_TUTOR
                                 IF acao_mac!="D"
                                    drvmouse=.f.
                                 ENDI
                              #endi

                           CASE opc_03=12     // sensibilidade mouse
                              cod_sos=45
                              AJMOUSE()

                        ENDC
                        CLEA GETS
                        CLOS ALL
                     ENDD
                     SAVE TO (arqconf) ALL LIKE drv*         // diferente do atual

                  CASE opc_02=9     // plano de senhas
                     IF nivelop < 3     // usuario pode acessar esta opcap?...
                        ALERTA()
                        DBOX(msg_auto,,,3)
                        LOOP
                     ENDI
                     cod_sos=17
                     MASENHA(1,54)
               ENDC
               CLEA GETS
               CLOS ALL
            ENDD

      ENDC
   END
   CLEA GETS
   CLOS ALL
ENDD

#ifndef COM_REDE
   EDBF(dbfpw,.f.)                                         // protege arquivo senhas
#endi

#ifdef COM_PROTECAO
   EVAL(protdbf,.f.)                                       // protege DBF
#endi

#ifdef COM_TUTOR
   IF acao_mac!="D"
      FCLOSE(handle_mac)
      acao_mac="D"
   END IF
#endi

RESTSCREEN(0,0,MAXROW(),79,v0)                             // s'imbora
SETPOS(MAXROW()-1,1)                                       // e cursor na penultima linha, coluna 1
RETU                                                       // volta ao DOS

* \\ Final de SFIN.PRG
