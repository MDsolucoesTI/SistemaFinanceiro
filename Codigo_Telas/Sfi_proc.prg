/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: SFI_PROC.PRG
 \ Data....: 30-07-96
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Rotinas auxiliares
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v3.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "sfin.ch"      // inicializa constantes manifestas

PROC CBC1(imp_cp)    // rotina para exibir pano de fundo
DISPBEGIN()                            // monta tela no buffer
SETCOLOR(drvcorpad)                    // imprime pano de fundo
CAIXA(REPL(drvcara,9),0,0,MAXROW(),79)
SETCOLOR(drvtitbox)
CAIXA(mold,13,26,22,74)                // monta caixa da tela
SETCOLOR(drvcorbox)
@ 14,27 SAY "      S I S T E M A  F I N A N C E I R O"
@ 15,27 SAY "                  VersÑo 2.0"
@ 16,27 SAY "      ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ"
@ 17,27 SAY "       Denny Paulista Azevedo Filho"
@ 18,27 SAY "ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ"
@ 21,27 SAY "        ,             -"
@ 21,37 SAY DATAC
@ 21,28 SAY NSEM(DATAC)
IF imp_cp                              // imprime campos do paramentro
   @ 19,33 SAY M->empresa1
   @ 21,52 SAY USUARIO
ENDI
DISPEND()                         // mostra tela que esta no buffer
RETU

PROC GBAK     // executa c¢pia backup
LOCAL t, i, pri_vez, espaco, vb, arqdbf, qt_lido, msg, msgt, testdb_, origem, destino
PRIV  dr_v, cn
ALERTA()                                                // emite um beep e solicita o
cod_sos=34                                              // drive para fazer o backup
dr_v=DBOX("A|B",,,E_MENU,,"DRIVE PARA O BACKUP")
pri_vez=.t.
IF dr_v>0                                               // escolheu um...
   dr_v=CHR(64+dr_v)+":\"                               // transforma opcao em letra (A:\)
   cn=.f.; disco_qtd=1                                  // inicializa variaveis de controle
   testdb_=1
   disco_num:=espaco := 0                               // do backup
   vb=SAVESCREEN(0,0,MAXROW(),79)                       // salva situacao da tela atual
   FOR t=1 TO nss                                       // faz backup de todos os arquivos

      #ifdef COM_REDE
         arqdbf=sistema[t,O_ARQUI]
         IF testdb_=1
            arqdbf+=".dbf"
         ELSE
            arqdbf=LEFT(arqdbf,3)+"_SEQ.dbf"
         ENDI
      #else
         arqdbf=sistema[t,O_ARQUI]+".dbf"
      #endi

      origem=ABRE(drvdbf+arqdbf,.f.)                    // abre arquivo de origem
      IF FERROR() !=0                                   // se ocorreu algum erro de abertura
         EXIT                                           // cancela o backup
      ENDI
      IF !pri_vez                                       // se nao for o 1o. arquivo
         destino=ABRE(dr_v+arqdbf,.t.)                  // cria-o no drive escolhido
         IF FERROR() !=0                                // se deu erro, entao
            EXIT                                        // cancela o backup
         ENDI
      ENDI
      buffer=SPAC(10000)                                // vamos ler 64k de cada vez
      qt_lido=FREAD(origem,@buffer,10000)               // le um pedaco do arq de origem
      DO WHIL !cn
         IF espaco>qt_lido .AND. !pri_vez               // se qde bytes lidos cabe no disquete
            FWRITE(destino,buffer,qt_lido)              // grava no destino
            espaco=DISKSPACE(ASC(dr_v)-64)-1024         // recalcula o espaco livre do disquete
            IF qt_lido!=10000                           // leu todo arquivo de origem
               EXIT                                     // passa para o proximo arquivo
            ENDI
            qt_lido=FREAD(origem,@buffer,10000)         // le mais um pedaco do arq de origem
         ELSE
            IF espaco>0 .AND. !pri_vez                  // o disco encheu...
               FWRITE(destino,buffer,espaco)            // grava o que der
               FCLOSE(destino)                          // fecha arquivo destino
               buffer=SUBS(buffer,espaco+1)             // retira do buffer os bytes ja gravados
               disco_dat = DATE()                       // salva no disquete a data do backup
               disco_arq = t                            // qde de arq que ja foram salvos
               disco_qtd++                              // qde de disquetes necessarios
               SAVE ALL LIKE disco_* TO &dr_v.CONTROLE.BKP
            ENDI
            RESTSCREEN(0,0,MAXROW(),79,vb)              // restaura tela
            disco_num++                                 // numero do disquete atual
            cod_sos=33
            msgt="BACKUP!|COLOQUE O DISCO Nß "+;        // monta mensagens
                 LTRIM(STR(disco_num))+" NO DRIVE "+dr_v
            msg ="Prosseguir|Cancelar operaáÑo"
            ALERTA()
            IF DBOX(msg,,,E_MENU,,msgt)!=1              // solicita um disquete
               cn=.t.; t=nss+2                          // cancelou o backup
            ELSE
               DBOX("AGUARDE!",,,,NAO_APAGA)            // mensagem ao usuario
               destino=ABRE(dr_v+arqdbf,.t.)            // abre arq no disquete
               IF FERROR() !=0                          // se deu erro, entao
                  t=nss+2                               // cancela o backup
               ELSE
                  FOR i=1 TO nss                        // mata do disquete todos os
                     db=dr_v+sistema[i,O_ARQUI]+".dbf"  // arquivos envolvidos no backup
                     IF FILE(db) .AND. db!=dr_v+arqdbf  // menos o arquivo atual
                        ERASE (db)
                     ENDI

                     #ifdef COM_REDE
                        db=dr_v+LEFT(sistema[i,O_ARQUI],3)+"_SEQ.dbf" // idem para o sequenciais
                        IF FILE(db) .AND. db!=dr_v+arqdbf
                           ERASE (db)
                        ENDI
                     #endi

                  NEXT
                  IF !pri_vez                           // se nao for o 1o. disquete
                     FWRITE(destino,buffer,LEN(buffer)) // grava restante dos bytes lidos,
                     buffer=SPAC(10000)                 // restaura o tamanho do buffer e
                     qt_lido=FREAD(origem,@buffer,10000)// le mais um pedaco do arq de origem
                  ENDI
                  disco_dat = DATE()                    // salva no disquete a data do backup
                  disco_arq = nss                       // e a provavel qde de arq salvos
                  SAVE ALL LIKE disco_* TO &dr_v.CONTROLE.BKP
                  espaco=DISKSPACE(ASC(dr_v)-64)-1024   // apura o espaco disponivel no disquete
                  pri_vez=.f.
               ENDI
            ENDI
         ENDI
      ENDD                                              // fim da copia do arquivo
      FCLOSE(origem)                                    // fecha arquivo de origem
      IF !cn                                            // se o backup nao foi cancelado,
         FCLOSE(destino)                                // fecha arquivo de destino

         #ifdef COM_REDE
            IF testdb_<2.AND.FILE(drvdbf+LEFT(sistema[t,O_ARQUI],3)+"_SEQ.dbf")
               testdb_=2
               t--
            ELSE
               testdb_=1
            ENDI
         #endi

      ENDI
   NEXT
   IF !cn                                               // se o backup nao foi cancelado,
      ALERTA()                                          // avisa ao usuario
      msg="BACKUP EXECUTADO COM SUCESSO!"
      DBOX(msg,,,,,"ATENCAO!")
   ENDI
ENDI
RETU

PROC RBAK     // recupera backup
LOCAL t, pri_vez, disco, espaco, vb, arqdbf, qt_lido, msg, msgt, testdb_, origem, destino
PRIV  dr_v, cn
ALERTA()
cod_sos=34                                                     // solicita o drive onde
dr_v=DBOX("A|B",,,E_MENU,,"DRIVE DO BACKUP")                   // esta' o disquete do backup
pri_vez=.t.
IF dr_v>0                                                      // informou A ou B
   dr_v=CHR(64+dr_v)+":\"                                      // transforma opcao em letra (A:\)
   testdb_=1
   cn=.f.; disco:=espaco := 0                                  // inicializa variaveis
   disco_qtd=1
   vb=SAVESCREEN(0,0,MAXROW(),79)                              // salva tela
   FOR t=1 TO nss                                              // restaura backup de todos arquivos

      #ifdef COM_REDE
         arqdbf=sistema[t,O_ARQUI]
         IF testdb_=1
            arqdbf+=".dbf"
         ELSE
            arqdbf=LEFT(arqdbf,3)+"_SEQ.dbf"
         ENDI
      #else
         arqdbf=sistema[t,O_ARQUI]+".dbf"
      #endi

      IF !pri_vez                                              // se nao for o 1o. arquivo
         origem=ABRE(dr_v+arqdbf,.f.)                          // abre arquivo de origem (no disquete)
         IF FERROR() !=0                                       // se deu erro, entao
            EXIT                                               // cancela a operacao
         ENDI
         destino=ABRE(drvdbf+arqdbf,.t.)                       // cria o arquivo no disco de destino
         IF FERROR() !=0                                       // se deu erro, entao
            EXIT                                               // cancela a operacao
         ENDI
      ENDI
      buffer=SPAC(10000)                                       // vamos ler 64k de cada vez
      DO WHIL !cn
         IF !pri_vez                                           // nao for o 1o. arquivo?
            qt_lido=FREAD(origem,@buffer,10000)                // le um pedacao do arquivo no disquete
            FWRITE(destino,buffer,qt_lido)                     // grava no seu destino
            IF qt_lido!=10000                                  // se chegou ao final do arquivo,
               EXIT                                            // pula para o proximo arquivo
            ENDI
         ELSE
            disco++
            msgt="RESTAURA BACKUP!|COLOQUE O DISCO Nß "+;
                  LTRIM(STR(disco))+" NO DRIVE "+dr_v
            RESTSCREEN(0,0,MAXROW(),79,vb)
            DO WHIL !cn
               cod_sos=33                                      // solicita a colocacao de um
               ALERTA(2)                                       // disquete no drive escolhido
               IF DBOX("Prosseguir|Cancelar operaáÑo",,,E_MENU,,msgt)!=1
                  cn=.t.; t=nss+2                              // cancelou a operacao
               ELSE
                  controle=ABRE(dr_v+"CONTROLE.BKP",.f.)       // abre arquivo de controle
                  IF FERROR() !=0                              // se deu erro
                     cn=.t.; t=nss+2                           // cai fora
                  ELSE
                     FCLOSE(controle)                          // fecha arquivo de controle e
                     RESTORE FROM &dr_v.CONTROLE.BKP ADDI      // le suas variveis de controle
                     IF disco != disco_num                     // o disco nao e' este...
                        ALERTA()
                        cod_sos=1
                        msg="Disco fora da seqÅància.|(nß "+LTRIM(STR(disco_num))+")"
                        DBOX(msg,,,3,,"ATENCAO!")
                        LOOP
                     ENDI
                     DBOX("AGUARDE!",,,,NAO_APAGA)
                     origem=ABRE(dr_v+arqdbf,.f.)              // abre o arquivo do disquete
                     IF FERROR() !=0
                        cn=.t.; t=nss+2                        // cancela se deu erro
                     ELSE
                        IF VALTYPE(destino)="U"                // se for o 1o. arquivo
                           destino=ABRE(drvdbf+arqdbf,.t.)     // cria...
                           IF FERROR() !=0                     // deu erro?...
                              cn=.t.; t=nss+2
                           ENDI
                        ENDI
                        pri_vez=.f.
                        EXIT
                     ENDI
                  ENDI
               ENDI
            ENDD
         ENDI
      ENDD                                                     // fim da copia do arquivo
      IF !cn                                                   // se operacao nao foi cancelada
         FCLOSE(origem)                                        // fecha arquivo do disquete
         IF t!=disco_arq .OR. disco_qtd=disco                  // foi o ultimo arq copiado pelo backup?
            FCLOSE(destino)                                    // fecha arquivo destino

            #ifdef COM_REDE
               IF testdb_<2.AND.FILE(dr_v+LEFT(sistema[t,O_ARQUI],3)+"_SEQ.dbf")
                  testdb_=2
                  t--
               ELSE
                  testdb_=1
               ENDI
            #endi

         ELSEIF t=disco_arq .AND. disco_qtd!=disco             // e' o ultimo arq copiado pelo backup?

            #ifdef COM_REDE
               IF testdb_<2.AND.FILE(dr_v+LEFT(sistema[t,O_ARQUI],3)+"_SEQ.dbf")
                  testdb_=2
                  FCLOSE(destino)
               ELSE
                  pri_vez=.t.
               ENDI
            #endi

            t--
         ENDI
      ENDI
   NEXT
   IF !cn                                                      // se deu tudo certo
      ALERTA()                                                 // avisa ao usuario
      msgt="BACKUP RESTAURADO COM SUCESSO!"
      msg ="Fazer a reconstruáÑo dos °ndices"
      DBOX(msg,,,,,msgt)
   ENDI
ENDI
RETU

PROC RCLA     // reconstroi indices
LOCAL msg, op_a:=1, ii, rcla_t
msg:=db := ""                                             // monta menu de dbf
FOR i=1 TO nss+IF(nivelop=3,1,0)                          // se for o gerente, entra
   IF LEN(sistema[i,O_INDIC])>0                           // tem indice definido?
      msg+="|"+sistema[i,O_MENU]                          // este entra no menu...
      db+=RIGHT(STR(100+i),2)                           // subscricao dentro de "sistema"
   ENDI
NEXT
rcla_t=SAVESCREEN(0,0,MAXROW(),79)                        // sava tela
DO WHIL op_a>0
   op_sis=1
   RESTSCREEN(0,0,MAXROW(),79,rcla_t)                     // escolhe um dbf para indexacao
   op_a=DBOX(SUBS(msg,2),03,54,E_MENU,NAO_APAGA,,,,op_a)
   IF op_a>0                                              // escolheu um...
      op_sis=op_a
      op_sis=VAL(SUBS(db,op_sis*2-1,2))                   // subscricao do arquivo
      dbf=sistema[op_sis,O_ARQUI]                         // nome do arquivo
      IF !EMPTY(dbf)
         IF op_sis=nss+1                                  // se for o arquivo de senha
            dbf=dbfpw                                     // pega o seu nome
         ELSE
            dbf=drvdbf+sistema[op_sis,O_ARQUI]            // nome do arquivo
         ENDI

         #ifdef COM_REDE
            IF !USEARQ(dbf,.t.,5,1,.f.)                   // se nao conseguiu abrir o dbf
               RETU                                       // cancela a operacao
            ENDI
         #else
            USE (dbf)                                     // abre o arquivo
         #endi

         DBOX("Classificando o arquivo",,,,NAO_APAGA,"AGUARDE!")
         FOR t=1 TO LEN(sistema[op_sis,O_INDIC])          // recria todos os ntx do arquivo
            IF op_sis=nss+1                               // se for o arquivo de senhas
               ntx=ntxpw                                  // este e' o nome do seu indice
            ELSE                                          // senao, este e um arquivo normal
               ntx=drvntx+sistema[op_sis,O_INDIC,t]       // e este e' o nome do seu indice
            ENDI
            chvind=sistema[op_sis,O_CHAVE,t]              // chave de indexacao
            INDE ON &chvind. TO (ntx)                     // indexando...
         NEXT
         CLOS ALL
      ENDI
      op_a++                                              // default para o proximo
   ENDI
ENDD
RETU

PROC COMPACTA    // exclusao fisica de registros
LOCAL msg, op_a:=1, ii, pack_t, db
msg:=db := ""
FOR i=1 TO nss                                   // monta menu de arquivos
   IF LEN(sistema[i,O_INDIC])>0                  // se tem indice
      msg+="|"+sistema[i,O_MENU]                 // este serve
      db+=RIGHT(STR(100+i),2)                    // subscricao dentro de "sistema"
   ENDI
NEXT
pack_t=SAVESCREEN(0,0,MAXROW(),79)               // salva tela
DO WHIL op_a>0
   op_sis=1
   RESTSCREEN(0,0,MAXROW(),79,pack_t)            // escolhe um arquivo para o pack
   op_a=DBOX(SUBS(msg,2),03,54,E_MENU,NAO_APAGA,,,,op_a)
   IF op_a>0                                     // escolheu um...
      op_sis=op_a                                // subscricao do dbf escolhido
      op_sis=VAL(SUBS(db,op_sis*2-1,2))        // subscricao do dbf em "sistema"
      dbf=sistema[op_sis,O_ARQUI]
      IF !EMPTY(dbf)
         dbf=drvdbf+sistema[op_sis,O_ARQUI]      // nome do dbf

         #ifdef COM_REDE
            IF !USEARQ(dbf,.t.,5,1)              // se nao conseguiu abrir o arquivo
               RETU                              // cancela a operacao
            ENDI
         #else
            USEARQ(dbf)                          // abre o arquivo
         #endi

         DBOX("Compactando o arquivo",,,,NAO_APAGA,"AGUARDE!")
         PACK                                    // excluindo mesmo...
         CLOS ALL                                // fecha o arquivo
      ENDI
      op_a++
   ENDI
ENDD
RETU

PROC CONFPRN     // Cria/Muda configuracao para a impressora
LOCAL i,l_,c_,op_imp:=1
PRIV  ar_prn, pd_prn                       // area do arquivo de configuracoes

pd_prn="1. IBM  9 pinos   |2. IBM 24 pinos   |3. Epson  9 pinos |"+;
       "4. Epson 24 pinos |5. Hp DeskJet     |6. Hp DeskJet Plus|"+;
       "7. Hp LaseJet II  |8. Hp LaseJet III  "        // padroes das impressoras
#ifdef COM_REDE
   IF ! USEARQ(arq_prn,.t.,20,1,.f.)       // falhou abertura modo
      RETU                                 // exclusivo, retorna
   ENDI
#else
   USE (arq_prn)                           // abre arquivo de configuracoes
#endi

ar_prn=SELECT()                            // qual e' o numero da area
DO WHIL .t.
   rel_imp=""                              // variavel que contera as configuracoes
   GO TOP                                  // ja existentes
   IF !EOF()
      DO WHIL !EOF()                       // le todo o arquivo
         rel_imp+="|"+ALLTRIM(marca)+;     // e vai montando a variavel
                  " em "+porta             // para o menu de configuracoes
         SKIP
      ENDD
   ENDI
   volta_ac=.f.                            // flag p/ dizer que o DEL foi
   rel_imp="* NOVA *"+rel_imp              // pressionado denotr da DBOX()
   cod_sos=42
   op_imp=DBOX(rel_imp,05,62,E_MENU,NAO_APAGA,,,,op_imp)
   IF volta_ac                             // quer apagar a configuracao?
      GO op_imp-1                          // posiciona nela e
      ALERTA()                             // pede confirmacao
      msg="Cancelar a operaáÑo|Efetivar exclusÑo"
      op_=DBOX(msg,,,E_MENU,,"EXCLUINDO CONFIGURAÄéO|Ø "+ALLTRIM(marca)+"em "+porta+" Æ")
      IF op_=2                             // se confirmou exclusao elimina
         DELE                              // o registro logicamente e
         PACK                              // fisicamente do arquivo
      ENDI
      LOOP                                 // retorna para menu de conf
   ENDI
   IF op_imp=0                             // ESC quer voltar
      EXIT
   ELSEIF op_imp=1                         // que fazer uma nova configuracao
      GO BOTT
      SKIP
   ELSE                                    // escolheu um configuracao ja pronta
      GO op_imp-1                          // posiciona dentro do dbf
   ENDI
   FOR i=1 TO FCOU()                       // cria variaveis de memoria
      msg=FIEL(i)                          // com o mesmo nome das variaveis
      M->&msg.=FIELDGET(i)                 // do arquivo
   NEXT
   SELE 0                                  // torna as variaveis visiveis
   cod_sos=18
   v4=SAVESCREEN(0,0,MAXROW(),79)          // salva tela
   DBOX(REPL("|",18),2,11,,NAO_APAGA,PADC("CONSULTE O MANUAL DA SUA IMPRESSORA",54,CHR(0)),,,,drvcortel)
   IF !EMPTY(padrao)                       // se existe um padrao...
      SETCOLOR(drvtittel)                  // imprime o seu nome
      @ 07,40 SAY SUBS(pd_prn,19*VAL(padrao)-18,18)
   ENDI
   SETCOLOR(drvcortel)                     // recebe as informacoes da configuracao

   @ 05,13 SAY "Marca da impressora.......";
           GET marca;                      // maraca da impressora
           WHEN "IMP_MARCA(marca)";
           VALI CRIT("!EMPT(marca)~MARCA Ilegal!")

   @ 06,13 SAY "Porta de sa°da............";
           GET porta PICT "@!";            // para ativa
           WHEN "IMP_PORTA(porta)";
           VALI CRIT("!EMPT(porta)~PORTA Ilegal!")

   @ 07,13 SAY "PadrÑo da impressora......";
           GET padrao PICT "@!";           // padrao da impressora
           WHEN "IMP_PADRAO(padrao)";
           VALI CRIT("padrao $ '12345678' ~PADRéO Ilegal!")

                                           // os codigos de impressao
   @ 08,13 SAY "Linhas por p†ginas........" GET tapg PICT "@S28"
   @ 09,13 SAY "   Ativa comprime 17,5 cpp" GET pcom PICT "@S28"
   @ 10,13 SAY "Desativa comprime 17,5 cpp" GET tcom PICT "@S28"
   @ 11,13 SAY "   Ativa comprime 20 cpp.." GET pc20 PICT "@S28"
   @ 12,13 SAY "Desativa comprime 20 cpp.." GET tc20 PICT "@S28"
   @ 13,13 SAY "   Ativa elite............" GET peli PICT "@S28"
   @ 14,13 SAY "Desativa elite............" GET teli PICT "@S28"
   @ 15,13 SAY "   Ativa negrito.........." GET penf PICT "@S28"
   @ 16,13 SAY "Desativa negrito.........." GET tenf PICT "@S28"
   @ 17,13 SAY "   Ativa expandido........" GET pexp PICT "@S28"
   @ 18,13 SAY "Desativa expandido........" GET texp PICT "@S28"
   @ 19,13 SAY "   Ativa 8 lin/pol........" GET pde8 PICT "@S28"
   @ 20,13 SAY "Desativa 8 lin/pol........" GET tde8 PICT "@S28"
   @ 21,13 SAY "   Ativa landscape........" GET land PICT "@S28"
   @ 22,13 SAY "Desativa landscape........" GET port PICT "@S28"
   READ
   SELE (ar_prn)                           // seleciona arq de configuracao
   IF LASTKEY()!=K_ESC                     // se nao abandonou com ESC
      IF EOF()                             // se quer incluir mais uma conf
         APPEND BLAN                       // cria um registro em branco
      ENDI
      FOR i=1 TO FCOU()                    // joga para o arquivo as
         msg=FIEL(i)                       // informacoes digitadas
         REPL &msg. WITH M->&msg.
      NEXT
   ENDI
   RESTSCREEN(0,0,MAXROW(),79,v4)          // restaura a tela anterior
ENDD
drvprn=IF(RECC()<drvprn,1,drvprn)          // ajusta configuracao atual
GO drvprn                                  // inicializa novamente as
FOR i=1 TO FCOU()                          // variaveis de impressao
   msg=FIEL(i)                             // para as novas configuracoes
   drv&msg.=ALLTRIM(FIELDGET(i))
NEXT
CLOSE ALL                                  // fecha o arquivo
RETU                                       // volta para o menu anterior

FUNC IMP_MARCA(m)   // escolhe a marca da impressora
LOCAL op_, msg, x:=1, mar_:=""
PRIV  cod_sos:=60
msg="Padrao IBM  |HP Laser IIP|"+;                // menu de modelos de
    "DeskJet 500 |Rima        |"+;                // impressoras
    "Epson       |Outras"
IF !EMPTY(m)                                      // se esta alterando uma conf
   x=AT(UPPER(LEFT(m,12)),UPPER(msg))             // procura o default
   x=IF(x>0,CONTA("|",LEFT(msg,x))+1,6)
ENDI
op_=DBOX(msg,05,60,E_MENU,,,,,x)                  // apresenta menu de impressoras
IF op_>0                                          // escolheu uma...
   IF EMPTY(m) .OR. op_!=x                        // e nao e a mesma
      mar_=PADR(SUBS(msg,1+13*(op_-1),12),15)     // sujestao do nome da marca
      IF op_!=6                                   // se nao for "outras" inicializa
         land=SPAC(40)                            // ativa landscape
         port=SPAC(40)                            // ativa portrait
         tapg=SPAC(40)                            // tamanho da pagina e
      ENDI
      DO CASE

         CASE op_=1                               //   * PADRAO IBM *
            padrao="1"                            // padrao
            tapg=PADR("CHR(27)+'C'+CHR(NNN)",40)  // tamanho da pagina
            pcom=PADR("CHR(15)",40)               // ativa comprimido 17,5 cpp
            tcom=PADR("CHR(18)",40)               // desativa comprimido 17,5 cpp
            pc20=PADR("CHR(30)+'5'",40)           // ativa comprimido 20 cpp
            tc20=PADR("CHR(30)+'0'",40)           // desativa comprimido 20 cpp
            peli=PADR("CHR(30)+'2'",40)           // ativa elite
            teli=PADR("CHR(30)+'0'",40)           // desativa elite
            penf=PADR("CHR(27)+'E'",40)           // ativa negrito
            tenf=PADR("CHR(27)+'F'",40)           // desativa negrito
            pexp=PADR("CHR(27)+'W'+CHR(1)",40)    // ativa expandido
            texp=PADR("CHR(27)+'W'+CHR(0)",40)    // desativa expandido
            pde8=PADR("CHR(27)+'0'",40)           // ativa 8 lin/pol
            tde8=PADR("CHR(27)+'2'",40)           // ativa 6 lin/pol

         CASE op_=2 .OR. op_=3                    //    * HP  LASER *
            padrao=IF(op_=2,"7","5")              // padrao
            pcom=PADR("CHR(27)+'(s16.67H'",40)    // ativa comprimido 17,5 cpp
            tcom=PADR("CHR(27)+'(s10H'",40)       // desativa comprimido 17,5 cpp
            pc20=PADR("CHR(27)+'(s16.67H'",40)    // ativa comprimido 20 cpp
            tc20=PADR("CHR(27)+'(s10H'",40)       // desativa comprimido 20 cpp
            peli=PADR("CHR(27)+'(s12H'",40)       // ativa elite
            teli=PADR("CHR(27)+'(s10H'",40)       // desativa elite
            penf=PADR("CHR(27)+'(s3B'",40)        // ativa negrito
            tenf=PADR("CHR(27)+'(s-3B'",40)       // desativa negrito
            pexp=PADR("CHR(27)+'(s3B'",40)        // ativa expandido
            texp=PADR("CHR(27)+'(s-3B'",40)       // desativa expandido
            pde8=PADR("CHR(27)+'(s1P'",40)        // ativa 8 lin/pol
            tde8=PADR("CHR(27)+'(s0P'",40)        // ativa 6 lin/pol
            land=PADR("CHR(27)+'&l1O'",40)        // ativa landscape
            port=PADR("CHR(27)+'&l0O'",40)        // ativa portrait

         CASE op_=4                               //    * RIMA *
            padrao="1"                            // padrao
            tapg=PADR("CHR(27)+'C'+CHR(NNN)",40)  // tamanho da pagina
            pcom=PADR("CHR(15)",40)               // ativa comprimido 17,5 cpp
            tcom=PADR("CHR(18)",40)               // desativa comprimido 17,5 cpp
            pc20=PADR("CHR(27)+'['+CHR(5)",40)    // ativa comprimido 20 cpp
            tc20=PADR("CHR(27)+'['+CHR(0)",40)    // desativa comprimido 20 cpp
            peli=PADR("CHR(27)+'['+CHR(2)",40)    // ativa elite
            teli=PADR("CHR(27)+'['+CHR(1)",40)    // desativa elite
            penf=PADR("CHR(27)+'E'",40)           // ativa negrito
            tenf=PADR("CHR(27)+'F'",40)           // desativa negrito
            pexp=PADR("CHR(27)+'W'+CHR(1)",40)    // ativa expandido
            texp=PADR("CHR(27)+'W'+CHR(0)",40)    // desativa expandido
            pde8=PADR("CHR(27)+'0'",40)           // ativa 8 lin/pol
            tde8=PADR("CHR(27)+'2'",40)           // ativa 6 lin/pol

         CASE op_=5                               //    * EPSON *
            padrao="3"                            // padrao
            tapg=PADR("CHR(27)+'C'+CHR(NNN)",40)  // tamanho da pagina
            pcom=PADR("CHR(15)",40)               // ativa comprimido 17,5 cpp
            tcom=PADR("CHR(18)",40)               // desativa comprimido 17,5 cpp
            pc20=PADR("CHR(27)+'M'+CHR(15)",40)   // ativa comprimido 20 cpp
            tc20=PADR("CHR(27)+'P'",40)           // desativa comprimido 20 cpp
            peli=PADR("CHR(27)+'M'",40)           // ativa elite
            teli=PADR("CHR(27)+'P'",40)           // desativa elite
            penf=PADR("CHR(27)+'E'",40)           // ativa negrito
            tenf=PADR("CHR(27)+'F'",40)           // desativa negrito
            pexp=PADR("CHR(27)+'W'+CHR(1)",40)    // ativa expandido
            texp=PADR("CHR(27)+'W'+CHR(0)",40)    // desativa expandido
            pde8=PADR("CHR(27)+'0'",40)           // ativa 8 lin/pol
            tde8=PADR("CHR(27)+'2'",40)           // ativa 6 lin/pol

      ENDC
      x=SETCOLOR(drvtittel)                       // reemprime codigos na tela
      @ 07,40 SAY SUBS(pd_prn,19*VAL(padrao)-18,18)
      @ 08,40 SAY tapg PICT "@S28"
      @ 09,40 SAY pcom PICT "@S28"
      @ 10,40 SAY tcom PICT "@S28"
      @ 11,40 SAY pc20 PICT "@S28"
      @ 12,40 SAY tc20 PICT "@S28"
      @ 13,40 SAY peli PICT "@S28"
      @ 14,40 SAY teli PICT "@S28"
      @ 15,40 SAY penf PICT "@S28"
      @ 16,40 SAY tenf PICT "@S28"
      @ 17,40 SAY pexp PICT "@S28"
      @ 18,40 SAY texp PICT "@S28"
      @ 19,40 SAY pde8 PICT "@S28"
      @ 20,40 SAY tde8 PICT "@S28"
      @ 21,40 SAY land PICT "@S28"
      @ 22,40 SAY port PICT "@S28"
      SETCOLOR(x)
   ENDI
ENDI
RETU mar_                                     // retorna sempre verdade

FUNC IMP_PADRAO(p)   // escolhe o padrao
LOCAL op_:=1, msg
PRIV  cod_sos:=61
IF !EMPTY(p)                                      // se esta alterando uma conf
   op_=VAL(p)                                     // procura o default
ENDI
op_=DBOX(pd_prn,05,60,E_MENU,,,,,op_)             // apresenta menu de padroes
IF op_>0                                          // escolheu um...
   x=SETCOLOR(drvtittel)                        // reemprime nome do padrao
   @ 07,40 SAY SUBS(pd_prn,19*op_-18,18)
   SETCOLOR(x)
   op_=LTRIM(STR(op_))
ELSE
   op_=""
ENDI
RETU op_                                      // retorna sempre verdade

FUNC IMP_PORTA(p,ap_ja_)    // menu de portas ativas
LOCAL msg:="", t, op_, tp_sai_:=""
PRIV  cod_sos:=37
FOR t=1 TO 3                                    // verifica quais as portas
   IF PARALELA(t)                               // paralelas estao ativa
      msg+="|Lpt"+STR(t,1)                      // para montar a varivel que
   ENDI                                         // contera o menu de portas
NEXT                                            // ativas
FOR t=1 TO 4
   IF SERIAL(t)                                 // idem para os portas
      msg+="|Com"+STR(t,1)                      // seriais...
   ENDI
NEXT
IF !EMPTY(msg)                                  // existe pelo menos um porta?
   op_=AT(p,UPPER(msg))
   msg=SUBS(msg,2)
   op_=IF(op_>0,CONTA("|",LEFT(msg,op_))+1,1)   // acha o defautl do menu
   op_=DBOX(msg,05,60,E_MENU,ap_ja_,,,,op_)     // apresenta menu
   IF op_>0                                     // escolheu uma...
      tp_sai_=UPPER(SUBS(msg,1+5*(op_-1),4))    // forca conteudo da porta
   ENDI
ENDI
RETU tp_sai_                                    // retorna sempre verdade

PROC CONFCORES      // ConfiguraáÑo de cores
LOCAL fez_conf:=.f.
NAOPISCA()                                               // habilita 256 cores (ega/vga)
maxfore=IF(CARDTYPE()>=V_EGA, 32, 16)                    // numero maximo de cores
maxcol =IF(CARDTYPE()>=V_EGA, 71, 39)                    // ultima coluna das cores

tb={;
     "N" , "B"  , "G"  , "BG" ,;                         // tabela de cores literais
     "R" , "RB" , "GR" , "W"  ,;
     "N+", "B+" , "G+" , "BG+",;
     "R+", "RB+", "GR+", "W+" ;
   }
qcor={;
       drvcorpad, drvcorbox, drvcormsg,;                 // cores configuraveis
       drvcorenf, drvcorget, drvcortel,;
       drvcorhlp;
     }

qtit={;
       drvtitpad, drvtitbox, drvtitmsg,;                 // cores de titulos configuraveis
       drvtitenf, drvtitget, drvtittel,;
       drvtithlp;
     }

SET CURSO OFF                                            // apaga cursor
SETCOLOR(drvcorbox)
CAIXA(mold+" ",12,5,23,maxcol)
FOR fundo=0 TO 7                                         // monta janela de selecao
   FOR frente=0 TO maxfore-1                             // das cores a serem configuradas
      cor=STR(frente,2)+"/"+STR(fundo,1)+IF(frente>15,"*","")
      SETCOLOR(cor)
      @ 14+fundo,6+(2*frente) SAY " ˛ "
   NEXT
NEXT
op_cor=1
DO WHILE .t.
   cod_sos=44
   msg="Pano do fundo|Janelas|Caixas de di†logos|Avisos e erros|Menus e campos|Tela de digitaáÑo|Janela de ajuda"
   op_cor=DBOX(msg,4,38,E_MENU,,,,,op_cor)
   IF op_cor=0                                           // volta ao menu
      EXIT
   ENDI
   fg=LEFT(qcor[op_cor],AT("/",qcor[op_cor])-1)          // cor da frente literal
   fg=ASCAN(tb,{|ve_a|fg==ve_a})                         // numero da cor da frente
   bg=SUBS(qcor[op_cor],AT("/",qcor[op_cor])+1)          // cor do fundo  literal
   IF "*" $ bg                                           // se 'blink` soma 16 na cor
      bg=STRTRAN(bg,"*"); fg=fg+16                       // da frente
   ENDI
   bg=ASCAN(tb,{|ve_a|bg==ve_a})                         // numero da cor do fundo
   ti=LEFT(qtit[op_cor],AT("/",qtit[op_cor])-1)          // cor da frente do titulo literal
   ti=ASCAN(tb,{|ve_a|ti==ve_a})                         // numero da cor da titulo
   tela_cor=SAVESCREEN(0,0,MAXROW(),79)
   qcor_antes=qcor[op_cor]; qtit_antes=qtit[op_cor]
   DO WHILE .t.
      SETCOLOR(qtit[op_cor])                             // monta janela para exemplo
      CAIXA(mold,4,33,12,64)                             // da selecao de cores
      @ 6,34 SAY REPL("ƒ",30)
      @ 5,34 SAY "EXEMPLO DO ESQUEMA SELECIONADO"
      SETCOLOR(qcor[op_cor])
      IF op_cor=1                                        // enche caixa-exemplo com
         FOR t=1 TO 5                                    // o fundo que estiver selecionado
            @ 6+t,34 SAY REPL(drvcara,30)
         NEXT
      ELSE                                               // mostra mensagens na caixa-exemplo
         @  8,34 SAY PADC(CHR(24)+" e "+CHR(25)+" muda fundo",30)
         @  9,34 SAY PADC("^"+CHR(27)+" e ^"+CHR(26)+" muda t°tulo",30)
         @ 10,34 SAY PADC("ENTER para aceitar esquema",30)
         @ 11,34 SAY PADC("ESC para terminar",30)
         IF op_cor=5                                     // se for menu, mostra como
            SETCOLOR(INVCOR(qcor[5]))                    // vai ficar
         ENDI
         @ 7,34 SAY PADC(CHR(27)+" e "+CHR(26)+" muda frente",30)
      ENDI
      SETCOLOR(drvcorbox)
      tc_=SAVESCREEN(12,5,23,maxcol)
      IF INT(fg/17)!=INT(ti/17)                          // fundo do titulo tem que
         ti=IF(fg>16,ti+16,ti-16)                        // ter a mesma cor do restante
      ENDI
      le=12+bg; ce=fg*2+4; ct=ti*2+5
      @ le,ce,le+2,ce+2 BOX LEFT(mold,8)                 // imprime caixa de selecao
      IF op_cor>1                                        // se nao for pano de fundo,
         @ 22,Ct SAY CHR(30)                             // imprime ponteiro de selecao
      ENDI                                               // da cor do titulo
      cod_sos=51

      #ifdef COM_MOUSE
         tecl=MOUSETECLA(14,7,22,7+(maxfore-1)*2)        // teclou algo ou clicou o mouse?
         IF tecl=CLICK                                   // o mouse foi clicado
            li:=co:=0
            MOUSEGET(@li,@co)                            // coordenadas do mouse
            IF li=22                                     // lin 22 quer modificar o titulo
               ct=co+IF(co%2=0,1,0)
               IF ti=(ct-5)/2                            // clicado 2 vezes no mesmo lugar
                  tecl=K_ENTER                           // forca saida da configuracao
               ELSE
                  ti=(ct-5)/2                            // calcula nova cor do titulo
                  tecl=32
               ENDI
            ELSE                                         // clicou em cima das cores
               le=li; ce=co-IF(co%2=0,0,1)
               IF bg=le-13 .AND. fg=(ce-4)/2             // 2 vezes no mesmo lugar
                  tecl=K_ENTER                           // forca saida
               ELSE
                  bg=le-13; fg=(ce-4)/2                  // calcula novas cores
                  tecl=32
               ENDI
            ENDI
         ENDI
      #else

         #ifdef COM_TUTOR
            tecl=IN_KEY(0)
         #else
            tecl=INKEY(0)                                // aguarda usuario teclar
         #endi

      #endi

      RESTSCREEN(12,5,23,maxcol,tc_)
      IF fg<17
         liminf=1; limsup=16
      ELSE
         liminf=17; limsup=32
      ENDI
      DO CASE
         CASE tecl=K_ESC                                 // abandonou
            qcor[op_cor]=qcor_antes                      // restaura cores anteriores
            qtit[op_cor]=qtit_antes
            EXIT

         CASE tecl=K_ENTER                               // escolheu cor
            EXIT

         CASE tecl=K_CTRL_D                              // pra direita
            fg=IF(fg<maxfore,fg+1,1)

         CASE tecl=K_CTRL_S                              // para esquerda
            fg=IF(fg>1 ,fg-1,maxfore)

         CASE tecl=K_CTRL_E                              // para cima
            bg=IF(bg>1,bg-1,7)

         CASE tecl=K_CTRL_X                              // para baixo
            bg=IF(bg<8,bg+1,1)

         CASE tecl=K_F1                                  // help
            EVAL(SETKEY(K_F1))

         CASE tecl=K_CTRL_RIGHT .AND. op_cor>1           // pra direita
            ti=IF(ti<limsup,ti+1,liminf)

         CASE tecl=K_CTRL_LEFT .AND. op_cor>1            // para esquerda
            ti=IF(ti>liminf,ti-1,limsup)

      ENDC
      /*
         converte cor numerica em cor literal
      */
      qcor[op_cor]=tb[fg-IF(fg>16,16,0)]+"/"+tb[bg]+IF(fg>16,"*","")
      qtit[op_cor]=tb[ti-IF(ti>16,16,0)]+"/"+tb[bg]+IF(fg>16,"*","")
   ENDD
   IF qcor[op_cor]!=qcor_antes .OR. qtit[op_cor]!=qtit_antes
      fez_conf=.t.                                       // trocou de cor
   ENDI
   RESTSCREEN(0,0,MAXROW(),79,tela_cor)
ENDD
SET CURSO ON                                             // acende o cursor
IF fez_conf                                              // configurou cores
   drvcorpad=qcor[1]; drvcorbox=qcor[2]                  // significa que as cores
   drvcormsg=qcor[3]; drvcorenf=qcor[4]                  // foram alteradas, entao,
   drvcorget=qcor[5]; drvcortel=qcor[6]                  // move para as variaveis do sistema
   drvcorhlp=qcor[7]
   drvtitpad=qtit[1]; drvtitbox=qtit[2]
   drvtitmsg=qtit[3]; drvtitenf=qtit[4]
   drvtitget=qtit[5]; drvtittel=qtit[6]
   drvtithlp=qtit[7]
   SETCOLOR(drvcorpad+","+drvcorget+",,,"+drvcortel)
   SAVE TO (arqconf) ALL LIKE drv*                       // grava configuracoes,
   corcampo=drvtittel                                    // cor "unselected"
   CBC1(.t.)
   v01=SAVESCREEN(0,0,MAXROW(),79)                       // salva para o break
   BREAK                                                 // forca a volta para o menu geral
ENDI
SET CURSO ON                                             // acende o cursor
RETU

PROC AJMOUSE      // Rotina para ajuste da sensibilidade do mouse
#ifdef COM_MOUSE
   IF drvmouse                                            // sensibilidade do mouse
      tpo:=tecl:=li:=co := 1; V=drvratV; H=drvratH
      msg="Horizontal: "+CHR(27)+LPAD(STR(H),3)+" "+CHR(26)+;
          "|Vertical..: "+CHR(27)+LPAD(STR(V),3)+" "+CHR(26)+;
          "|(P)adrÑo - 'default`|"+gcr+" = Ok"
      DBOX(msg,,,,NAO_APAGA,"AJUSTA SENSIBILIDADE DO MOUSE")
      MOUSEBOX(0,0,MAXROW(),79)                           // define area de atuacao
      SETCOLOR(drvcorbox)
      SET CURSOR OFF                                      // apaga o cursor do CA-Clipper e
      MOUSECUR(.t.)                                       // acende o cursor do mouse
      DO WHIL tecl!=K_ESC .AND. tecl!=K_ENTER
         clic=MOUSEGET(@li,@co)                           // capta coordenadas atuais

         #ifdef COM_TUTOR
            tecl=IN_KEY()                                 // verifica algo digitado
         #else
            tecl=INKEY()                                  // verifica algo digitado
         #endi

         IF clic=1 .OR. tecl=80 .OR. tecl=112             // se clicado botao esquerdo ou 'P`
            press=(SECONDS()>tpo+1)                       // tempo maximo retido = 1s
            IF tpo=0 .OR. press                           // se 1o. click ou tempo esgotado
               IF (li=13 .AND. co>28 .AND. co<49) .OR.;   // verifica local clicado
                  tecl=80 .OR. tecl=112                   // e muda a sensibilidade
                  H=8; V=16                               // horizontal e vertical
               ELSEIF li=11 .AND. co>40 .AND. co<44
                  H=H-IF(H>1,1,0)
               ELSEIF li=11 .AND. co>45 .AND. co<49
                  H=H+IF(H<900,1,0)
               ELSEIF li=12 .AND. co>40 .AND. co<44
                  V=V-IF(V>1,1,0)
               ELSEIF li=12 .AND. co>45 .AND. co<49
                  V=V+IF(V<900,1,0)
               ELSEIF li=14 .AND. co>35 .AND. co<43       // clicou OK
                  tecl=K_ENTER
               ENDI
               MOUSERAT(H,V)                              // ajusta sensibilidade escolhida
               MOUSECUR(.f.)                              // esconde cursor do mouse e
               @ 11,43 SAY LPAD(STR(H),3)                 // mostra valores horizontal
               @ 12,43 SAY LPAD(STR(V),3)                 // e vertical
               MOUSECUR(.t.)                              // exibe novamente o cursor
               tpo=IF(tpo=0,SECONDS(),tpo)                // reinicializa tempo max retencao
            ENDI
         ELSEIF clic=2                                    // pressionou botao direito,
            tecl=K_ESC                                    // entao forca retorno
         ELSEIF tecl=K_F1                                 // se teclou f1,
            HELP()                                        // apresenta ajuda
         ELSE                                             // ou entao,
            tpo=0                                         // zera tempo de retencao
         ENDI
      ENDD
      MOUSECUR(.f.)                                       // apaga o cursor do mouse
      COLORSELECT(COR_PADRAO)
      SET CURSOR ON                                       // acende o cursor do CA-Clipper
      IF tecl=K_ESC                                       // se abandonou,
         MOUSERAT(drvratH,drvratV)                        //  retorna sensibilidade original
      ELSE                                                // senao,
         drvratH=H; drvratV=V                             //  prepara gravacao dos valores
      ENDI                                                //  de sensibilidade escolhidos
   ENDI
#endi
RETU

PROC MASENHA(lin_menu,col_menu)  // Manipula o plano de senhas
PRIV op_sis:=nss+1

#ifdef COM_REDE
   IF ! USEARQ(dbfpw,.t.,5,1)                         // se falhou abertura de senhas
      RETU                                            //  exclusivo, retorna
   ENDI
#else
   USE (dbfpw) INDE (ntxpw)                           // abre arquivo de senhas
#endi

IF nivelop<3                                          // so pode trocar a senha
   TROCASENHA()
ELSE                                                  // esse e' o chefe...
   cod_sos=17                                         // se F1, mostraremos o help 17
   IF ASC(nace)<49 .OR. ASC(nace)>51                  // se esta criptografado
      REPL ALL nace WITH DECRIPT(nace),;              // descriptografa o nivel
               nome WITH DECRIPT(nome)                // e o nome dos usuarios
   ENDI
   GO TOP
   SET KEY K_F9 TO TROCASENHA()                       // F9 troca a senha do gerente
   EDITA(MAXROW()/4,3,MAXROW()/2,77,"PGXVNJZ")
   SET KEY K_F9 TO                                    // desabilida tecla F9
   PACK                                               // elimina usuarios excluidos
   REPL ALL nace WITH ENCRIPT(nace),;                 // criptografa o nivel e
            nome WITH ENCRIPT(nome)                   // o nome dos usuarios
ENDI
CLOS ALL                                              // fechando o arquivo
RETU

PROC TROCASENHA()
LOCAL rg_:=RECNO()
PRIV cod_sos:=16
SAVE SCREEN
SETCOLOR(drvtittel)
tem_borda=.t.
l_s=Sistema[op_sis,O_TELA,O_LS]                    // coordenadas da tela
c_s=Sistema[op_sis,O_TELA,O_CS]
l_i=Sistema[op_sis,O_TELA,O_LI]
c_i=Sistema[op_sis,O_TELA,O_CI]
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)              // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)                        // monta caixa da tela
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "     USUèRIO "+usuario
@ l_s+03,c_s+1 SAY " Senha atual:"
@ l_s+04,c_s+1 SAY " Senha nova.:"
@ l_s+05,c_s+1 SAY "              (ESC recomeáar)"
senha=PADR(PWORD(l_s+3,c_s+15),6)                  // recebe a senha
IF senha!=senhatu .AND. !EMPT(senha)               // epa! e' um ET!
   ALERTA()                                        // beep, beep, beep
   DBOX(usuario+",|Sua senha nÑo confere!",14,40,3,,"ATENÄéO!")
ELSEIF !EMPT(senha)                                // senao, pode alterar
   DO WHIL .t.
      senhatu=PADR(PWORD(l_s+04,c_s+15),6)         // recebe nova senha
      IF senha!=senhatu .AND. !EMPT(senhatu)       // e diferente da atual
         SEEK senhatu                              // verifica se um outro usuario
         IF FOUND()                                // esta' usando esta senha
            ALERTA()
            msg="Senha inv†lida"                   // boing... vamos dar qualquer
            DBOX(msg,l_s+04,c_s+19,3,,"ATENÄéO!")  // aviso, a menos que esta senha
            @ l_s+04,c_s+15 SAY SPAC(6)            // pertenca a outro usuario
         ELSE                                      // senha ok.
            SEEK senha                             // posiciona sobre o registro
            REPL pass WITH senhatu                 // e muda a senha
            EXIT
         ENDI
      ELSE                                         // senhas nao foi alterada
         senhatu=senha                             // restabelece a senha
         EXIT                                      // cai fora
      ENDI
   ENDD
ENDI
GO rg_
REST SCREEN
RETU

PROC PW_INCL       // Inclui novos operadores no plano de senha
LOCAL getlist := {}, ult_reg:=RECNO()
PRIV op_menu
op_menu=INCLUSAO
tem_borda=.t.
SETCOLOR(drvtittel)
l_s=Sistema[op_sis,O_TELA,O_LS]                // coordenadas da tela
c_s=Sistema[op_sis,O_TELA,O_CS]
l_i=Sistema[op_sis,O_TELA,O_LI]
c_i=Sistema[op_sis,O_TELA,O_CI]
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)          // pega posicao atual da tela
CAIXA(mold,l_s,c_s,l_i,c_i)                    // monta caixa da tela
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "       DADOS DO USUèRIO"
@ l_s+03,c_s+1 SAY " Nome.:"
@ l_s+04,c_s+1 SAY " Nivel:"
@ l_s+05,c_s+1 SAY " Senha:        (ESC recomeáar)"
SELE 0
nome=SPACE(15); nace=" "                       // inicializa variaveis da inclusao
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
DO WHILE .t.
   rola_t=.f.
   SET KEY K_ALT_F8 TO ROLATELA                // habilita ALT-F8 (rolagem da tela)
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   @ l_s+03,c_s+09 GET  NOME;                  // nome do operador
                   PICT sistema[op_sis,O_CAMPO,02,O_MASC];
                   VALI CRIT(sistema[op_sis,O_CAMPO,02,O_CRIT])

   @ l_s+04,c_s+09 GET  NACE;                  // nivel de acesso
                   WHEN sistema[op_sis,O_CAMPO,03,O_WHEN];
                   VALI CRIT(sistema[op_sis,O_CAMPO,03,O_CRIT])

   READ
   SET KEY K_ALT_F8 TO                         // desabilita tecla ALT-F8
   IF rola_t                                   // quer rolar a tela?
      ROLATELA()                               // entao rola
      LOOP                                     // e volta para redigitar
   ENDI
   EXIT
ENDD
SELE SFIPW
IF LASTKEY()!=K_ESC                            // se nao cancelou a inclusao
   DO WHIL .t.
      senhatu=PWORD(l_s+05,c_s+09)             // recebe a senha
      SEEK senhatu                             // verifica se outro usuario
      IF FOUND()                               // esta usando esta senha
         ALERTA()
         msg="Senha inv†lida"                  // boing... vamos dar qualquer
         DBOX(msg,l_s+04,c_s+19,3,,"ATENÄéO!") // aviso, a menos que esta senha
         @ l_s+05,c_s+09 SAY SPAC(6)           // pertenca a outro usuario
      ELSE                                     // senha ok.
         APPE BLAN                             // cadastro o usuario
         REPL pass WITH senhatu, nome WITH M->nome, nace WITH M->nace
         EXIT
      ENDI
   ENDD
ELSE
   GO ult_reg                                  // retorna para registro anterior
ENDI
RETU

PROC BROWSE_REL(arq_, l_sup_, c_sup_,l_inf_, c_inf_)
LOCAL cur_atual, cor_atual
PRIV l_arq[l_inf_-l_sup_+1], maxlin_, area_, tablin_, fim_arq_, offset_ini,;
     offset_fim, lsup_:=l_sup_+1, csup_:=c_sup_+1,linf_:=l_inf_-1, t_w, t_r, ;
     cinf_:= c_inf_-1, cod_sos:=55, t_c, t_s, t_d, t_3, t_4, t_7, t_9, t_10
t_w:=SETKEY(K_CTRL_W,NIL); t_r:=SETKEY(K_CTRL_R,NIL)       // desabilita teclas
t_c:=SETKEY(K_CTRL_C,NIL); t_s:=SETKEY(K_CTRL_S,NIL)       // cursoras
t_d:=SETKEY(K_CTRL_D,NIL)
t_3:=SETKEY(K_F3,NIL);  t_4:=SETKEY(K_F4,NIL)              // desabilita teclas
t_7:=SETKEY(K_F7,NIL);  t_9:=SETKEY(K_F9,NIL)              // de funcoes
t_10:=SETKEY(K_F10,NIL)
IF AT(".",arq_)=0                     // se o arquivo nao tiver extensao
   arq_+=".prn"                       // vamos forcar ".prn"
ENDI
IF (area_:=FOPEN(arq_))<0             // abre arquivo modulo binario
   ALERTA(2)                          // arquivo nao foi aberto...
   msg="NÑo foi possivel abrir o arquivo!"
   DBOX(msg,,,3,,"ATENCAO!")
   RETU
ENDI                                  // moldura da janela
cor_atual=SETCOLOR(drvcortel)         // cor da janela do browse
cur_atual:=SETCURSOR(0)               // salva/apaga cursor
CAIXA(mold,l_sup_,c_sup_,l_inf_,c_inf_)

#ifdef COM_MOUSE
   msg=" "+CHR(174)+" "+CHR(175)+;    // botoes do mouse
       " "+CHR(30)+" "+CHR(31)+;
       " "+CHR(24)+" "+CHR(26)+;
       " "+CHR(25)+" "+CHR(27)+" "
   posi_cur=c_inf_-c_sup_-17          // posicao onde eles comecam
   posi_cur=c_sup_+INT(posi_cur/2)
   IF drvmouse                        // se o mouse esta abilitado
      @ l_inf_,posi_cur SAY msg       // imprime msg no rodape da janela
   ENDI
#endi

maxlin_=linf_-lsup_+1                 // qtde maxima de linhas da janela
AFILL(l_arq,"")                       // inicializa vetor das linhas mostradas
offset_ini:=offset_fim := 0           // inicializa ponteiros de inicio e
tablin_ = 1                           // da area mostrada
fim_arq_=FSEEK(area_,0,FS_END)        // tamanho do arquivo
FSEEK(area_,0)                        // volta para o topo do arquivo
MONTA_LIN(maxlin_,0)                  // le/imprime as primeiras linhas
offset_ini=0                          // reinicializa offset de inicio
DO WHILE .t.

   #ifdef COM_MOUSE
      tecl_p=MOUSETECLA(l_inf_,posi_cur,;
                        l_inf_,posi_cur+16,;   // aguarda com controle de mouse
                        .f.;
             )
   #else

      #ifdef COM_TUTOR
         tecl_p=IN_KEY(0)             // espera tecla ser digitada
      #else
         tecl_p=INKEY(0)              // espera tecla ser digitada
      #endi

   #endi

   IF SETKEY(tecl_p)!=NIL           // executa funcao associada a
      EVAL(SETKEY(tecl_p))            // tecla digitada se existir
      tecl_p=0                        // nao faz mais nada depois
   ENDI
   DO CASE
      CASE tecl_p=K_ESC               // fim do browse no arquivo
         EXIT

      CASE tecl_p=K_DOWN              // seta para baixo
         MONTA_LIN(1,0)

      CASE tecl_p=K_UP                // seta para cima
         MONTA_LIN(-1,0)

      CASE tecl_p=K_CTRL_PGUP         // inicio do arquivo
         offset_ini:=offset_fim := 0
         AFILL(l_arq,"")
         MONTA_LIN(maxlin_,0)
         offset_ini=0

      CASE tecl_p=K_CTRL_PGDN         // fim do arquivo
         offset_ini:=offset_fim := fim_arq_
         AFILL(l_arq,CHR(0))
         @ l_sup_+1,c_sup_+1 CLEAR TO l_inf_-1,c_inf_-1
         MONTA_LIN(-1*(maxlin_),0)

      CASE tecl_p=K_RIGHT             // seta para direita
         MONTA_LIN(0,10)

      CASE tecl_p=K_LEFT              // seta para esquerda
         MONTA_LIN(0,-10)

      CASE tecl_p=K_PGDN              // pagina para baixo
         MONTA_LIN(maxlin_-1,0)

      CASE tecl_p=K_PGUP              // pagina cima/final do arquivo
         MONTA_LIN(-1*(maxlin_-1),0)

      CASE tecl_p=73.OR.tecl_p=105    // impressao do relatorio
         MONTA_IMP(cur_atual)

   END CASE
ENDD
FCLOSE(area_)                         // fecha arquivo .prn
SETKEY(K_CTRL_W,t_w); SETKEY(K_CTRL_R,t_r)       // habilita teclas
SETKEY(K_CTRL_C,t_c); SETKEY(K_CTRL_S,t_s)       // cursoras
SETKEY(K_CTRL_D,t_d)
SETKEY(K_F3,t_3); SETKEY(K_F4,t_4)               // habilita teclas
SETKEY(K_F7,t_7); SETKEY(K_F9,t_9)               // de funcoes
SETKEY(K_F10,t_10)

SETCURSOR(cur_atual)                  // restaura cursor
SETCOLOR(cor_atual)                   // e a cor
RETU

STATIC PROC MONTA_LIN(qtlin_,qttab_)  // le/imprime linhas do arquivo binario
LOCAL t_, i_, x_, j_, lin_, buf_, tambuf_, ini_, fim_, qts_:=0,;
      tp_cmd:="pcomtcompc20tc20pelitelipenftenfpexptexppde8tde8landport"
IF qtlin_!=0                                     // quer le outras linhas?
   tambuf_=ABS(qtlin_)*270                       // buffer maximo do tamnho das linhas
   IF qtlin_<0 .AND. offset_ini>1                // quer voltar linhas e nao esta no topo
      IF offset_ini<tambuf_                      // se o tamanho buffer e maior do que
         tambuf_=offset_ini                      // ja foi lido, ajusta seu tamanho
      ENDI
      FSEEK(area_,offset_ini-tambuf_)            // posiciona poteiro para a leitura
      buffer_=SPAC(tambuf_)                      // inicializa o buffer e
      FREAD(area_,@buffer_,tambuf_)              // le o arquivo...
      buffer_=STRTRAN(buffer_,CHR(12)+CHR(13),CHR(13)+CHR(10))
      tambuf_++                                  // incrementa tamanho do buffer
      buf_=tambuf_                               // salva tamanho original
      FOR t_ = qtlin_ TO -1                      // faz p/ todas as linhas requeridas
         IF tambuf_ > 1                          // se nao esta no inicio do buffer
            tambuf_-=3                           // tira o CR+LF do fim da linha
            i_=tambuf_                           // acha o ultimo CR+LF
            tambuf_=RAT(CHR(13)+CHR(10),SUBS(buffer_,1,tambuf_))
            tambuf_=IF(tambuf_>0,tambuf_+2,1)    // se achou desconta o CR+LF
            IF l_arq[maxlin_]!=CHR(0)            // se a linha a excluir for do arquivo
               offset_fim-=LEN(l_arq[maxlin_])+2 // decrementa seu tamanho do offset do
            ENDI                                 // fim do arquivo (acresentando o CR+LF)
            AINS(l_arq,1)                        // insere um linha no top do arranjo
            i_=i_-tambuf_+1
            l_arq[1]=SUBS(buffer_,tambuf_,i_)    // inicializa a linha com a linha do arq
            qts_--                               // qtde de linhas do scroll
         ELSE                                    // se chegou no inicio do tamanho do
            EXIT                                 // buffer lido, cai fora...
         ENDI
      NEXT
      offset_ini-=buf_-tambuf_                   // ajusta offset da linha inicio da janela

   ELSEIF l_arq[2]!=CHR(0)                       // quer avancar linhas e nao esta no fim do arq
      FSEEK(area_,offset_fim)                    // posiciona o ponteiro na ultima lin lida
      IF offset_fim+tambuf_>fim_arq_             // se o resto do arquivo e menor do que
         tambuf_=fim_arq_-offset_fim             // o tamanho do buffer, ajusta seu tamanho
      ENDI
      buffer_=SPAC(tambuf_)                      // inicializa o buffer e
      FREAD(area_,@buffer_,tambuf_)              // le o arquivo...
      buffer_=STRTRAN(buffer_,CHR(12)+CHR(13),CHR(13)+CHR(10))
      FOR t_ = 1 TO qtlin_                       // mostra proximas linhas requeridas
         IF l_arq[1]!=CHR(0)                     // se for uma linha lida do arquivo
            offset_ini+=LEN(l_arq[1])+2          // ajusta offset do inicio
         ENDI
         ADEL(l_arq,1)                           // apaga a 1a. linha do arranjo
         qts_++                                  // qtde de linhas que sera feita o scroll
         IF LEN(buffer_)<3                       // se nao tem mais linha para montar a tela
            l_arq[maxlin_]=CHR(0)                // inicializa linha com CHR(0) (flag)
            IF l_arq[2]=CHR(0)                   // se o fim do arq esta na 1a. linha
               EXIT                              // nao tem mais linha para mostrar
            ENDI
         ELSE                                    // caso contrario pega linha corrente
            l_arq[maxlin_]=PARSE(@buffer_,CHR(13)+CHR(10))
            offset_fim+=LEN(l_arq[maxlin_])+2    // ajusta offset do fim da janela
         ENDI
      NEXT
   ENDI
ENDI
IF (qttab_<0 .AND. tablin_>1) .OR.;              // quer rolar horizontalmente?
   (qttab_>0 .AND. tablin_<230)
   tablin_+=qttab_                               // soma/diminui tabulacao atual
   qts_=maxlin_                                  // forca remontagem de toda a janela
ENDI
IF qts_!=0                                       // se leu alguma linha
   SCROLL(lsup_,csup_,linf_,cinf_,qts_)          // rola a tela
   ini_=IF(qts_>0,maxlin_-qts_+1,1)              // inicio e fim das linhas
   fim_=IF(qts_>0,maxlin_,ABS(qts_))             // que foram lidas
   i_=cinf_-csup_+1                              // tamanho da janela
   FOR t_=ini_ TO fim_                           // imprime linhas lidas
      lin_=l_arq[t_]
      IF !EMPTY(lin_).AND.!OK_PRINT(lin_)        // tem caraceter de controle?
         IF AT(" "+CHR(8),lin_)>0                // tira efeito especial da frente da linha
            lin_=SUBS(lin_,AT(" "+CHR(8),lin_)+2)
         ENDI
         FOR j_=1 TO 56 STEP 4                   // testa todos os carc de controle
            x_="drv"+SUBS(tp_cmd,j_,4)             // monta o nome do efeito
            x_=&x_.
            IF !EMPTY(x_)                          // tem efeito configurado?
               lin_=STRTRAN(lin_,&x_.,"")          // retira-o da linha
            ENDI
         NEXT
      ENDI
      @ lsup_+t_-1,csup_ SAY SUBS(lin_,tablin_,i_)
   NEXT
ENDI
RETU

STATIC PROC MONTA_IMP(cur_atual)  // imprime arquivo
LOCAL pgini_, tp, g_off_ini, g_off_fim, qt_lido, buf_, ctpag_, lin_, t_
SAVE SCREEN                                                  // salva tela
SETCURSOR(cur_atual)                                         // acende cursor
pgini_=DBOX("P†gina inicial:",1,45,,NAO_APAGA,"IMPRIME ARQUIVO",1,"99999")
SETCURSOR(0)                                                 // apaga cursor
IF pgini_>0
   porta=IMP_PORTA(drvporta,NAO_APAGA)                       // escolhe para onde vai
   IF !EMPT(porta) .AND. LASTKEY()<>K_ESC
      IF PREPIMP()                                           // pede para preparar impressora
         DBOX("AGUARDE!",,,,NAO_APAGA)                       // mensagem ao usuaruio
         g_off_ini=offset_ini                                // salva ponteiros do arquivo
         g_off_fim=offset_fim
         SET ALTE TO (porta)                                 // abre o dispositivo de impressao
         SET ALTE ON                                         // liga gravacao
         SET CONS OFF                                        // nao iremos exibir na tela
         FSEEK(area_,0)                                      // inicio do arquivo
         qt_lido=200                                         // qtde de bytes que vamos ler
         buf_=SPAC(200)                                      // vamos ler os primeiros 200 bytes
         qt_lido=FREAD(area_,@buf_,200)                      // para ver se tem efeito especial...
         IF LEN(buf_)>0                                      // leu alguma coisa...
            IF AT(" "+CHR(8),buf_)>0                         // se tem algum efetio vamos
               lin_=PARSE(buf_," "+CHR(8))                   // extrai so o efeito e
               ? lin_                                        // envia para a impressora
            ENDI
         ENDI
         FSEEK(area_,0)                                      // inicio do arquivo
         qt_lido=10000                                       // qtde de bytes que vamos ler
         buf_=""
         ctpag_=1                                            // contador de pagina
         DO WHILE qt_lido=10000
            buffer_=SPAC(10000)                              // inicializa o buffer e le arquivo...
            qt_lido=FREAD(area_,@buffer_,10000)              // le o arquivo...
            buffer_=buf_+buffer_                             // soma o final do buffer anterior
            buf_=""                                          // no buffer atual
            DO WHILE LEN(buffer_)>0                          // imprime as linhas do buffer lido
               lin_=PARSE(@buffer_,CHR(13)+CHR(10))          // separa uma linha
               IF LEN(buffer_)>0 .OR. qt_lido<>10000         // se nao for a ultima do buffer
                  IF ctpag_<pgini_                           // se esta pg nao podemos imprimir
                     t_=AT(CHR(12)+CHR(13),lin_)             // verifica chr de salto de pg
                     IF t_>0                                 // tem?
                        ctpag_++                             // soma no contador
                        lin_=SUBS(lin_,t_+2)                 // pega a linha de inicio da pg
                     ENDI
                  ENDI

                  #ifdef COM_TUTOR
                     IF IN_KEY()=K_ESC                       // se quer cancelar
                  #else
                     IF INKEY()=K_ESC                        // se quer cancelar
                  #endi

                     IF canc()                               // pede confirmacao
                        qt_lido=0                            // confirmou,
                        EXIT                                 // prepara para sair...
                     ENDI
                  ENDI
                  IF ctpag_>=pgini_                          // se ja podemos imprimir
                     ? lin_                                  // grava no dispositivo de imprissao
                  ENDI
               ELSE                                          // fima do buffer a linha pode
                  buf_=lin_                                  // estar incompleta, salva o resto
               ENDI
            ENDD
         ENDD
         SET ALTE OFF                                        // desliga a gravacao
         SET ALTE TO                                         // fecha dispositivo de impressao
         SET CONS ON                                         // reabilita o video
         offset_ini=g_off_ini                                // restaura ponteiros do arquivo
         offset_fim=g_off_fim
      ENDI
   ENDI
ENDI
REST SCREEN                                                  // restabelece tela
RETU

PROC DOSCOM    // Executa comandos do DOS (shell)
LOCAL dos_t:=SAVESCREEN(0,0,MAXROW(),79), cor_atual:=SETCOLOR("W+/N"),;
      cur_sor:=SETCURSOR(3)
CLS
QOUT("Digite EXIT para retornar")
! command                         // carrega copia do command.com
MUDAFONTE(drvfonte)               // troca a fonte de caracteres
NAOPISCA()                        // habilita 256 cores (ega/vga)
RESTSCREEN(0,0,MAXROW(),79,dos_t) // restaura tela e
SETCOLOR(cor_atual)               // o esquema de cor
SETCURSOR(cur_sor)
RETU

PROC FILTRA(flg,ord)  // Monta seleáÑo de registros

/*
   Se flg=.t., cria indice temporario
   Se ord=.t., alem da filtragem, oferece ordenacao
*/
LOCAL m_campos, op_sis, getlist:={}, cn:=.f.
PRIV cod_sos:=12
cpsel:=criterio :="" ; selnum:=i :=0
op_sis=EVAL(qualsis,ALIAS())                             // subscricao do vetor sistema

/*
   enche m_campos com titulos dos campos (para menu)
*/
IF nivelop>=NIV_CRI_LIVRE                                // se usuario autorizado,
   m_campos="|* * CritÇrio livre * *"                    //  pode fazer filtragem livre
ELSE                                                     // senao,
   m_campos=""                                           //  nao vai ter esta opcao
ENDI
nc=IF(brw,br_w:colcount,FCOU())                          // numero de campos para escolher
FOR i=1 TO nc                                            // monta menu de campos
   IF brw                                                // se chamado da EDITA()
      cargox=br_w:getcolumn(i):cargo                     //  desmembra coluna em:
      cp_=PARSE(@cargox,"≥")                             //  nome do campo
      ms_=PARSE(@cargox,"≥")                             //  mascara
      ti_=PARSE(@cargox,"≥")                             //  titulo
      m_campos+="|"+ti_                                  //  monta menu de campos
   ELSE                                                  // senao,
      IF !("I"==sistema[op_sis,O_CAMPO,i,O_CRIT])        //  monta menu de campos
         m_campos+="|"+sistema[op_sis,O_CAMPO,i,O_TITU]  //  exceto invisivel
      ENDI
   ENDI
NEXT
m_campos=SUBS(m_campos,2)                                // despreza 1a. barra
op_6=1
m_criterio=""
DO WHIL selnum<6 .AND. cpsel!=SPAC(10)                   // permite escolher somente 3 criterios
   selnum++                                              // contador de criterios
   IF selnum>1                                           // ja foi feito pelo menos um criterio
      m_tit="FILTRAGEM|OPERADORES L¢GICOS|*"+m_criterio
      op_2=DBOX("* Ok! *|E|OU",,,E_MENU,,m_tit)          // recebe operadores
      IF op_2=0                                          // cancelou
         criterio=""; cn=.t.                             // limpa criterio existente
         EXIT                                            // e retorna
      ENDI
      IF op_2=1                                          // criterio montado ok
         cpsel=SPAC(10)                                  // prepara para sair
         LOOP
      ELSE
         op_2=TRIM(SUBS(".AND..OR. ",(op_2-1)*5-4,5))    // operador escolhido
         criterio  +=op_2                                // junta operador ao criterio
         m_criterio+="|"+op_2                            // monta titulo para proxima dbox()
      ENDI
   ENDI
   cpsel=SPAC(10) ; messaux=criterio
   m_tit="FILTRAGEM|CAMPOS DO ARQUIVO|*"+m_criterio
   op_1=DBOX(m_campos,,,E_MENU,,m_tit)                   // escolhe campo para filtrar
   IF op_1=0                                             // cancelou
      criterio=""; cn=.t.                                // limpa criterio existente
      EXIT                                               // e retorna
   ENDI
   IF nivelop>=NIV_CRI_LIVRE                             // usuario pode fazer criterio livre
      IF op_1=1                                          // foi selecionado
         selnum=0 ; clivre=.t.
         EXIT
      ENDI
      op_1--                                             // com criterio livre, ha' mais um item
   ENDI                                                  // no menu, portanto, ajusta op_1 para
   IF brw                                                // se chamado da EDITA()
      cargox=br_w:getcolumn(op_1):cargo                  //  desmembra coluna para
      cpsel=PARSE(@cargox,"≥")                           //  pega o campo e a
      selpic=PARSE(@cargox,"≥")                          //  mascara
   ELSE                                                  // senao,
      ii=0
      FOR i=1 TO FCOU()                                  // acha campo escolhido
         IF !("I"==sistema[op_sis,O_CAMPO,i,O_CRIT])
            ii++                                         // desprezando campos
         ENDI                                            // invisiveis
         IF ii=op_1                                      // campo escolhido?
            cpsel=FIEL(i)                                //  seu nome e
            selpic=sistema[op_sis,O_CAMPO,i,O_MASC]      //  sua mascara
            EXIT
         ENDI
      NEXT
   ENDI
   tp_cp=VALTYPE(&cpsel.)                                // tipo do campo?
   m_tit="FILTRAGEM|OPERADORES RELACIONAIS|*"+;
         m_criterio+"|"+TRIM(cpsel)
   m_relac="=  Igual a      ˇ|"+;
           "#  Diferente de ˇ|"
   IF tp_cp!="L"                                         // logico so '= ou #`
      m_relac=m_relac+"<  Menor que    ˇ|"+;
                      "<= Menor ou igual|"+;
                      ">  Maior que    ˇ|"+;
                      ">= Maior ou igual"
   ENDI
   IF AT(tp_cp,"CM")>0                                   // se tipo caracter ou memo tem $ (contem)
      m_relac=m_relac+"|$  ContÇm       ˇ|!$ NÑo contÇm   ˇ"
   ENDI
   op_6=DBOX(m_relac,,,E_MENU,,m_tit)                    // pega operando
   IF op_6=0                                             // cancelou com ESC
      criterio=""; cn=.t.                                // limpa criterio existente
      EXIT                                               // e retorna
   ENDI
   op_s=TRIM(SUBS("= # < <=> >=$ $ ",op_6*2-1,2))        // inicializa seg oper=tipo do campo
   IF tp_cp="D"
      oper_2=CTOD("")
   ELSEIF tp_cp="N"
      oper_2=0
   ELSE
      oper_2=SPAC(LEN(&cpsel.))
   ENDI
   m_tit="FILTRAGEM: SEGUNDO OPERANDO|*"+m_criterio+"|"+TRIM(cpsel)+op_s
   oper_2=DBOX("Segundo operando (nÑo use aspas):",,,,,m_tit,oper_2,selpic)
   IF LASTKEY()=K_ESC                                    // cancelou
      selnum=0                                           // zera numero de criterios,
      criterio=""; cn=.t.                                // e o criterio parcialmente definido
      EXIT                                               // para retornar
   ENDI
   IF tp_cp="D"
      oper_2="CTOD(["+DTOC(oper_2)+"])"
   ELSEIF tp_cp="N"
      oper_2=LTRIM(TRAN(oper_2,""))
   ELSE
      IF EMPT(oper_2)
         oper_2="'"+oper_2+"'"
      ELSE
         oper_2="'"+TRIM(oper_2)+"'"
      ENDI
   ENDI
   IF op_6>6
      IF op_6=8                                          // operador "nao contem" (!$)
         cpsel="!("+oper_2+PADC(op_s,3)+;
               TRIM(cpsel)+")"
      ELSE
         cpsel=oper_2+PADC(op_s,3)+TRIM(cpsel)           // operador "contem" ($)
      ENDI
   ELSE
      cpsel=TRIM(cpsel)+op_s+oper_2                      // outros operadores
   ENDI
   criterio+=cpsel                                       // monta o criterio
   m_criterio+="|"+cpsel                                 // monta msg para dbox()
ENDD
IF selnum>0 .AND. !cn                                    // ha criterio feito
   IF flg                                                // vamos criar indice temporario
      IF ord!=NIL                                        // e possivelmente, ordenar
         ALERTA()
         cod_sos=21
         msg="Ordenar o arquivo|Prosseguir operaáÑo"     // ve se usuario quer ordenar
         op_=DBOX(msg,,,E_MENU,,"CLASSIFICAÄéO DO ARQUIVO")
         IF op_=1                                        // sim! quer...
            cpord=""
            CLASS(.f.)                                   // entao, ordena
         ENDI
      ENDI
      INDTMP()                                           // cria indice temporario
   ENDI
ELSEIF !cn
   IF clivre                                             // monta criterio livre
      criterio=SPAC(210)
      msg="A EXPRESSéO ABAIXO DEVERè ESTAR DE ACORDO COM|"+;
          "A SINTAXE DA LINGUAGEM PARA EVITAR ERRO DE PROCESSAMENTO|*|"+;
          "F10=CAMPOS DO ARQUIVO|*|INFORME A EXPRESSéO FILTRO:"
      DO WHILE .t.
         SET KEY K_F10 TO ve_campos                      // F10 monta menu de campos
         criterio=DBOX(msg,,,,,SEPLETRA("* FILTRAGEM LIVRE *",1),criterio,"@S50")
         SET KEY K_F10 TO
         IF LASTKEY()=K_ESC                              // cancelou
            criterio=""; cn=.t.
            EXIT
         ENDI
         tp_crit=TYPE(criterio)                          // se a expressao=indeterminada
         IF tp_crit="UI"                                 // existe funcao fora da clipper.lib na
            tp_crit=VALTYPE(&criterio.)                  // expressao, logo avalia o seu
         ENDI                                            // conteudo
         IF tp_crit="L"                                  // se o tipo da expressao for
            EXIT                                         // logico, entao segue em frente
         ENDI
         ALERTA(3)
         DBOX("EXPRESSéO ILEGAL",15)
      ENDD
      IF !cn
         criterio=ALLTRIM(criterio)                      // tira brancos da expressao
         IF !EMPT(criterio) .AND. flg                    // vai criar indice temporario
            IF ord!=NIL                                  // e ordenar o arquivo se quiser
               CLASS(.f.)
            ENDI
            INDTMP()                                     // cria indice temporario
         ENDI
      ENDI
   ENDI
ENDI
IF EMPT(criterio) .AND. INDEXKEY(0)="LTOC("              // se tirou o filtro
   INDTMP()                                              // indexa o dbf novamente
ENDI
RETU

PROC VEOUTROS    // Abre opáÑo de consulta a outros arquivos
LOCAL op_a:=0, chvpesq, opm:=ARRAY(nss), db, tp, t_w, t_r, t_c, t_7, t_9,;
                  v_:=SAVESCREEN(0,0,MAXROW(),79), reg_dbf:={}
PRIV cod_sos:=23, v_ar:=READVAR()
t_w:=SETKEY(K_CTRL_W,NIL)                                // desabilita e salva
t_r:=SETKEY(K_CTRL_R,NIL)                                // as teclas de controle
t_c:=SETKEY(K_CTRL_C,NIL)
t_7:=SETKEY(K_F7,NIL); t_9:=SETKEY(K_F9,NIL)
reg_dbf=POINTER_DBF()                                    // salva situacao de todos dbf's
msg:=db := ""
FOR i=1 TO nss                                           // monta menu
   IF sistema[i,O_OUTROS,O_NIVEL]<=nivelop .AND. LEN(sistema[i,O_INDIC])>0
      msg+="|"+sistema[i,O_MENU]                            // de nomes de arquivos
      db+=RIGHT(STR(100+i),2)
   ENDI
NEXT
IF LEN(msg)>1
   op_a=DBOX(SUBS(msg,2),,3,E_MENU,,"BASE DE DADOS")      // qual arquivo?
ENDI
IF op_a>0                                                // selecionado um...
   op_a=VAL(SUBS(db,op_a*2-1,2))
   db=sistema[op_a,O_ARQUI]                              // nome do arquivo (sem dir)
   tem_t=.f.
   IF !EMPTY(v_ar)                                       // alguma variavel pendente?
      IF  VALTYPE(&v_ar.) $ "CNDL"                       // se for caracter, numerica, data
         tem_t=!("OP_" $ UPPER(v_ar))                    // ou logica e nao for de menu,
         v_ar=TRANSCAMPO(.t.,v_ar)                       // pode transferir campos
      ENDI                                               // para o get pendente
   ENDI
   PTAB(IF(tem_t,v_ar,"^%"),db)                          // abre arquivo e tenta posicionar
                                                         // com conteudo do get pendente
   #ifdef COM_REDE
      IF NETERR()                                        // se deu erro de abertura,
         RETU                                            // retorna
      ENDI
   #endi

   SELE &db.                                             // seleciona o arquivo escolhido
   IF EOF()                                              // se fim de arquivo,
      GO TOP                                             // vai para o 1o. registro
   ENDI
   v_out=.t.
   cod_sos=8
   EDITA(09,10,MAXROW()-3,70)                            // consulta e faz projecoes
   v_out=.f.
ENDI
POINTER_DBF(reg_dbf)                                     // restaura ponteiro dos dbf's
SETKEY(K_CTRL_W,t_w)                                     // restaura teclas de controle
SETKEY(K_CTRL_R,t_r)
SETKEY(K_CTRL_C,t_c)
SETKEY(K_F7,t_7); SETKEY(K_F9,t_9)
RESTSCREEN(0,0,MAXROW(),79,v_)                           // restaura tela
RETU

PROC VE_CAMPOS   // Abre janela com nomes de campos
LOCAL ve_op:="", t_f10:=SETKEY(K_F10,NIL), ii                      // evita recursividade
PRIV cod_sos:=26
FOR i=1 TO FCOU()                                                  // monta menu com nomes e titulos
   IF !("I"==sistema[EVAL(qualsis,ALIAS()),O_CAMPO,i,O_CRIT])      //  exceto campos invisiveis
      ve_op+="|"+sistema[EVAL(qualsis,ALIAS()),O_CAMPO,i,O_TITU]+" ("+FIEL(i)+")"
   ENDI
NEXT
op_campo=DBOX(SUBS(ve_op,2),,50,E_MENU,,"CAMPOS DO ARQUIVO")       // apresentar menu de campos
IF op_campo>0                                                      // escolheu um campo
   ii=0
   FOR i=1 TO FCOU()                                               // sincriniza opcao escolhida
      IF !("I"==sistema[EVAL(qualsis,ALIAS()),O_CAMPO,i,O_CRIT])   // com o campo equivalente
         ii++
      ENDI
      IF ii=op_campo                                               // e este o campo
         KEYB ALLTRIM(FIEL(i))                                     // coloca no buffer do teclado
         EXIT                                                      // seu nome (nome em arquivo)
      ENDI
   NEXT
ENDI
SETKEY(K_F10,t_f10)                                                // reabilita F10
RETU

PROC INDTMP    // Cr°a °ndices tempor†rios
LOCAL op_sis, ind_ok, ind_an, arqtmp, ind01, ind02
op_sis=EVAL(qualsis,ALIAS())                         // subscricao do vetor sistema

/*
   se pediu ordenacao e nao e' indice de pesquisa ou ha filtragem,
   cria novo arquivo indice
*/

IF LEN(cpord)>1 .OR. !EMPT(criterio) .OR.;           // se tem ordenacao ou filtro
   INDEXORD()>LEN(sistema[op_sis,O_CHAVE])           // ou esta usando indice temporario
   arqtmp=drvntx+LEFT(ALIAS(),3)+ide_maq+".ntx"      // nome arquivo ntx temporario
   ind_ok=0
   nord:=juncao_ := ""
   IF !EMPT(criterio)                                // tem filtro?
      nord="LTOC("+criterio+")"; juncao_="+"         // indexa pela condicao
   ENDI
   IF !EMPT(chv_rela)                                // a janela esta relacionada?
      chv_=INDEXKEY(0)                               // chave do indice atual
      IF chv_="LTOC("                                // se existir filtro na chave
         chv_=SUBS(chv_,6); x_=1                     // vamos tirar a sua expressao
         DO WHILE x_!=0                              // ltoc(...)+...
            p_=LEFT(chv_,1)
            x_=x_+IF(p_=")",-1,IF(p_="(",1,0))
            chv_=SUBS(chv_,2)
         ENDD
         chv_=SUBS(chv_,2)                           // retira o "+" da frente
      END IF
      p_=CONTA("+",chv_rela)+1                       // quantidade de campos da relacao
      DO WHILE p_-->0                                // extrai os campos do indice
         nord+=juncao_+PARSE(@chv_,"+"); juncao_="+" // monta expressao do indice
      ENDD
   ENDI
   IF LEN(cpord)>1                                   // se escolheu outra ordenacao
      nord+=juncao_+cpord                            // vamos usa-la
   ELSE                                              // caso contrario
      nord+=juncao_+UPPE(INDEXKEY(1))                // concatena com o indice basico
   ENDI
   qt_ind=LEN(sistema[op_sis,O_INDIC])
   FOR t=1 TO qt_ind                                 // ordem escolhida e' igual
      IF UPPE(INDEXKEY(t))=UPPE(nord)                // a algum indice de pesquisa?
         ind_ok=t                                    // sim! vamos usa'-lo
         EXIT
      ENDI
   NEXT
   IF ind_ok=0
      ind_t=SAVESCREEN(0,0,MAXROW(),79)              // sava tela e da msg
      DBOX("Criando °ndice tempor†rio",,,,NAO_APAGA)
      INDE ON &nord. TO (arqtmp)                     // indexando...
      RESTSCREEN(0,0,MAXROW(),79,ind_t)
      IF op_sis<=nss                             // se nao for as senhas,
         ind01=drvntx+sistema[op_sis,O_INDIC,1]  //  coloca o path
      ELSE                                       // senao,
         ind01=sistema[op_sis,O_INDIC,1]         //  o indice ja tem o path
      ENDI
      IF qt_ind=1
         SET INDE TO (ind01), (arqtmp)
      ELSE
         ind02=drvntx+sistema[op_sis,O_INDIC,2]
         IF qt_ind=2
            SET INDE TO (ind01), (ind02), (arqtmp)
         ENDI
      ENDI
      ind_ok=qt_ind+1                                // ordem do indice a usar
   ENDI
   SET ORDE TO (ind_ok)                              // usa a ordem apropriada
   REGINICIO()                                       // verifica se reg esta' no filtro
ENDI
RETU

PROC REP  // Liga/desliga repetiáÑo de registro
IF op_menu=INCLUSAO .AND. !EMPT(READVAR())
   fgrep=!fgrep
   im_aj_at_=1            // var usada dentro da GETSYS para
ENDI                      // imprimir informacoes no rodape'
RETU

PROC CONF  // Liga/desliga confirmaáÑo em campos
IF op_menu=INCLUSAO .AND. !EMPT(READVAR())
   drvconf=!drvconf
   SET CONF (drvconf)     // ajusta SET CONFIRM
   im_aj_at_=1            // var usada dentro da GETSYS para
ENDI                      // imprimir informacoes no rodape'
RETU

PROC CLASS(conf_ord_)  //  Pega seqÅància de campos para ordenar arquivo
LOCAL menucp:="", op_sis, clivre:=.f., msg, cpord_antes:=cpord,;
      qt_ind, op_ord:=0, tela_class:=SAVESCREEN(0,0,MAXROW(),79)
PRIV cod_sos:=14
op_sis=EVAL(qualsis,ALIAS())                         // qual subsistema?
qt_ind=LEN(sistema[op_sis,O_CHAVE])                  // qde de indices do arquivo
IF qt_ind>1                                          // se mais de um indice,
   msg=""                                            // escolhe por menu o conjunto
   FOR t=1 to qt_ind                                 // de indice desejado para a
      msg+="|"+sistema[op_sis,O_CONSU,t]             // nova ordenacao
   NEXT
   msg+="|* OUTRA ORDEM *"                           // ou deixa escolher qualquer campo
   op_ord=DBOX(SUBS(msg,2),,,E_MENU,,"SELECIONE A ORDENAÄéO")
   DO CASE
      CASE op_ord=0                                  // quer abandonar...
         op_ord=1

      CASE op_ord=qt_ind+1                           // quer escolher qualquer campo
         op_ord=0

      OTHERWISE                                      // escolheu um indice...
         cpord+=IF(LEN(cpord)>1,"+","")+;            // comcatena o indice com a
                sistema[op_sis,O_CHAVE,op_ord]       // ordenacao pre-definida
   ENDC
ENDI
IF op_ord=0                                     // quer definir uma ordenacao...
   msg=IF(EMPTY(cpord),"","*"+cpord)
   nc=IF(brw,br_w:colcount,FCOU())              // numero de campos para escolher a ordem
   IF nivelop>=NIV_CRI_LIVRE                    // verifica se usuario autorizado a fazer
      menucp="|* * OrdenaáÑo livre * *"         // ordenacao livre
   ENDI
   FOR i=1 TO nc                                // monta menu de campos
      IF brw                                    // se chamado da EDITA()
         cargox=br_w:getcolumn(i):cargo         //  desmembra coluna em:
         cp_=PARSE(@cargox,"≥")                 //  nome do campo
         ms_=PARSE(@cargox,"≥")                 //  mascara
         ti_=PARSE(@cargox,"≥")                 //  titulo
         menucp+="|"+ti_                        //  e monta menu de campos
      ELSE                                      // senao, monta menu de campos
         IF !("I"==sistema[op_sis,O_CAMPO,i,O_CRIT])     //  exceto campos invisiveis
            menucp+="|"+sistema[op_sis,O_CAMPO,i,O_TITU]
         ENDI
      ENDI
   NEXT
ENDI
DO WHIL op_ord=0
   IF LEN(msg)>0                                // mostra campos escolhidos
      op_0=DBOX(SUBS(msg,2),,50,,NAO_APAGA,"ORDENAÄéO")
   ENDI
   op_0=DBOX(SUBS(menucp,2),,6,E_MENU,,"CAMPOS PARA ORDENAR|O ARQUIVO")
   IF op_0!=0                                   // escolheu um campo
      op_1=op_0
      IF nivelop>=NIV_CRI_LIVRE                 // se tem autorizacao para ordenacao
         IF op_1=1                              // livre, entao faz...
            clivre=.t.
            EXIT
         ENDI
         op_1--                                 // faz op_1 a subscricao do campo ou coluna
      ENDI
      IF brw                                    // se chamado da EDITA()
         cargox=br_w:getcolumn(op_1):cargo      // desmembra coluna em campo, mascara e titulo
         cp_=PARSE(@cargox,"≥")
         ms_=PARSE(@cargox,"≥")
         ti_=PARSE(@cargox,"≥")
      ELSE
         ii=0
         FOR i=1 TO FCOU()                           // acha campo escolhido
            IF !("I"==sistema[op_sis,O_CAMPO,i,O_CRIT])
               ii++                                  // desprezando campos
            ENDI                                     // invisiveis
            IF ii=op_1                               // campo escolhido?
               cp_=FIEL(i)                           // seu nome e seu
               ti_=sistema[op_sis,O_CAMPO,i,O_TITU]  // titulo
               EXIT
            ENDI
         NEXT
      ENDI
      IF TYPE(cp_) $ "MLU"                       // se tipo MEMO, LOGICO ou INDEFINIDO...
         ALERTA(3)                               // ... nao da' para usar
         DBOX("Campo "+MAIUSC(ti_)+" nÑo|pode ser usado para ordenaáÑo",,,,,"ATENÄéO!")
         LOOP
      ENDI
      cp_=TRANSCAMPO(.f.,cp_)                    // transforma paara caracter
      msgt="ESCOLHA O SENTIDO DA ORDENAÄéO|DO CAMPO "+MAIUSC(ti_)
      op=DBOX("Crescente|Decrescente",,,E_MENU,,msgt)
      msg +="|"+ti_
      IF op=2                                    // pediu ordem decrescente
         cp_="DESCEND("+cp_+")"
         msg+=" (Decrescente)"
      ENDI
      cpord+=IF(LEN(cpord)>1,"+","")+cp_         // concatena campos escolhidos
   ELSE
      EXIT
   ENDI
ENDD
IF clivre                                        // vai fazer ordenacao livre
   cpord=SPAC(210)
   msg="A EXPRESSéO ABAIXO DEVERè ESTAR DE ACORDO COM|"+;
       "A SINTAXE DA LINGUAGEM PARA EVITAR ERRO DE PROCESSAMENTO|*|"+;
       "F10=CAMPOS DO ARQUIVO|*|INFORME A EXPRESSéO PARA ORDENAÄéO"
   DO WHILE .T.
      SET KEY K_F10 TO ve_campos                 // habilita F10 para ver campos DBF
      cpord=DBOX(msg,,,,,SEPLETRA("* ORDENAÄéO  LIVRE *",1),cpord,"@S50")
      SET KEY K_F10 TO                           // desabilita F10
      IF LASTKEY()=K_ESC
         cpord=""                                // cancelou...
         EXIT
      ENDI
      tp_crit=TYPE(cpord)
      IF tp_crit="UI"                            // se expressao=indeterminado
         tp_crit=VALTYPE(&cpord.)                // existe funcao fora da clipper.lib
      ENDI                                       // entao avalia o conteudo da expressao
      IF tp_crit $ "CND"                         // so ordena tipos caracter/numerico/data
         IF tp_crit="N"                          // transf p/ caracter ordem tp numerica
            cpord="STR("+ALLTRIM(cpord)+")"
         ELSEIF tp_crit="D"                      // transf p/ caracter ordem tp data
            cpord="DTOS("+ALLTRIM(cpord)+")"
         ENDI
         EXIT                                    // vamos retornar, ordenacao ajustada
      ENDI
      ALERTA(3)                                  // ordenacao livre invalida
      DBOX("EXPRESSéO ILEGAL",15)                // vamos avisar...
   ENDD
   cpord=ALLTRIM(cpord)                          // tira brancos da expressao
ENDI
RESTSCREEN(0,0,MAXROW(),79,tela_class)           // restaura tela original
IF !EMPTY(cpord) .AND. conf_ord_ .AND.;          // mudou a ordenacao e quer
   cpord_antes!=cpord                            // que confirma a ordenacao?
   IF op_ord=0                                   // se nao escolheu um ja existente
      ALERTA(1)                                  // beep! e
      msg="Prosseguir|Cancelar"                  // ve se usuario quer ordenar
      msgt="ORDENAÄéO DO ARQUIVO"                // realmente o arquivo
      cod_sos=1
      ii=DBOX(msg,,,E_MENU,,msgt)
      IF ii!=1                                   // se desistiu,
         cpord=cpord_antes                       //  volta ordenacao anterior
      ELSE                                       // senao,
         INDTMP()                                //  cria indice temporario
      ENDI
   ELSE
      INDTMP()                                   // seleciona indice escolhido
   ENDI
ENDI
RETU

PROC POSI   // Recebe argumentos e pesquisa arquivo
LOCAL op_sis, i, ii, iii, tip, j_, msg, ind, qt_ind
PRIV cod_sos
op_sis=EVAL(qualsis,ALIAS())               // subscricao do vetor Sistema
ind=INDEXORD(1)                            // salva ordem atual
DO WHIL op_sis>0
   cod_sos=24
   qt_ind=LEN(sistema[op_sis,O_INDIC])     // qde de indices do arquivo
   chv=ATAIL(sistema[op_sis,O_CHAVE])      // pega ultimo elemento das chaves
   IF chv=="codlan"                        // e ve se e' ntx de relacionamento
      qt_ind--                             // se for, nao pode ser escolhido
   ENDI
   IF qt_ind>1                             // se mais de um,
      msg=""                               // escolhe por menu o conjunto de pesquisa
      FOR t=1 to qt_ind
         msg+="|"+sistema[op_sis,O_CONSU,t]
      NEXT
      op_posi=DBOX(SUBS(msg,2),,,E_MENU,,"SELECIONE A PESQUISA",,,op_posi)
      IF op_posi=0                         // cancelou
         DBSETORDER(ind)                   // restaura ordem anterior
         RETU                              // e retorna
      ENDI
   ELSE
      op_posi=1                            // so um indice, usa 1o. cj pesquisa
   ENDI
   SET ORDE TO op_posi                     // usa o conjunto de pesquisa escolhido
   chvpesq:=msg:=""
   cod_sos=25

   /*
      Pega cada um dos campos chaves do conjunto de pesquisa selecionado.
      A variavel sistema[op_sis,O_ORDEM,1] possui, a cada dois digitos,
      os numeros de ordem dos campos escolhidos para chave.
      Exemplo: "010305"     (campos 1, 3 e 5 compoem a chave do conj pesquisa)
   */
   FOR i=1 TO LEN(sistema[op_sis,O_ORDEM,op_posi]) STEP 2       // para cada chave...
      ii=VAL(SUBS(sistema[op_sis,O_ORDEM,op_posi],i,2))         // ordem do campo
      tip=VALTYPE(&(FIELD(ii)))                                 // tipo do campo
      IF tip="C"                                                // inicializa variavel
         chv=SPAC(LEN(&(FIELD(ii))))                            // p/ receber argumento
      ELSEIF tip="N"                                            // de acordo com o tipo
         chv=0                                                  // do campo
      ELSEIF tip="D"
         chv=CTOD('')
      ELSEIF tip="L"
         chv=.t.
      ENDI
      gab=sistema[op_sis,O_CAMPO,ii,O_MASC]                     // mascara do campo
      chv=DBOX(msg+"Informe "+;                                 // recebe argumento de pesquisa
          sistema[op_sis,O_CAMPO,ii,O_TITU],,,,,"PROCURA REGISTRO",chv,gab)
      IF (EMPT(chv).AND.tip!="L") .OR. LASTKEY()=K_ESC          // cancelou ou informou parte
         EXIT
      ENDI
      msg=msg+sistema[op_sis,O_CAMPO,ii,O_TITU]+": "+;          // prepara mensagem do
          TRAN(chv,gab)+"||"                                    // titulo da janela
      chvpesq=chvpesq+TRANSCAMPO(.t.,"chv",ii)                  // transforma p/ caracter
   NEXT
   chvpesq=TRIM(chvpesq)                                        // tira espacos
   IF EMPT(chvpesq) .OR. LASTKEY()=K_ESC                        // cancelou ou nao informou
      EXIT
   ENDI
   ultreg=RECN()                                                // salva registro corrente
   SEEK chvpesq                                                 // procura
   IF FOUND() .AND. &(INDEXKEY(ind))=IF(EMPT(criterio),"","T")+chv_1
      EXIT                                                      // este serve...
   ELSE                                                         // nao serviu
      GO ultreg                                                 // volta ao registro
      ALERTA(2)
      DBOX(msg+"nÑo encontrado, "+usuario,,,2,,"ATENÄéO!")      // vamos avisar ao usuario
   ENDI
ENDD
DBSETORDER(ind)                                                 // usa ordem original
RETU

PROC EDIT   // ManutenáÑo de arquivos
LOCAL prgets, prget1, princl, li, co, tecl_p, msg, sos_cod:=cod_sos,;
      i, ii, ultreg, ord_dbf, t_w, t_r, t_c
PRIV  tem_borda, chv_rela:="", chv_1:="", chv_2:=""
prget1=LEFT(ALIAS(),3)+"_get1"                       // nome prg para modificar o registro
princl=LEFT(ALIAS(),3)+"_incl"                       // nome prg para inclusao de registros

/*
   compila code block em tempo de execucao para apresentar os campos/tela
*/
prgets=&("{||"+LEFT(ALIAS(),3)+"_gets()}")
sistema[op_sis,O_TELA,O_ATUAL]=1
edic=1
tbmenu="PSADMERFOG"                                  // letras iniciais das opcoes
FOR i=1 TO LEN(exrot[op_sis])                     // exclui comando da lista
   tbmenu=STRTRAN(tbmenu,SUBS(exrot[op_sis],i,1),"")
NEXT
msg_menu=""
msg_menu+=IF(AT("P",tbmenu)>0,"Procura|","")         // variavel contendo opcoes
msg_menu+=IF(AT("S",tbmenu)>0,"Seguinte|","")        // do menu de edicao
msg_menu+=IF(AT("A",tbmenu)>0,"Anterior|","")
msg_menu+=IF(AT("D",tbmenu)>0,"Digita|","")
msg_menu+=IF(AT("M",tbmenu)>0,"Modifica|","")
msg_menu+=IF(AT("E",tbmenu)>0,"Exclui|","")
msg_menu+=IF(AT("R",tbmenu)>0,"Recupera|","")
msg_menu+=IF(AT("F",tbmenu)>0,"Filtra|","")
msg_menu+=IF(AT("O",tbmenu)>0,"Ordena|","")
msg_menu+=IF(AT("G",tbmenu)>0,"Global","")
t_w:=SETKEY(K_CTRL_W,NIL)                               // desabilita e salva
t_r:=SETKEY(K_CTRL_R,NIL)                               // as teclas de controle
t_c:=SETKEY(K_CTRL_C,NIL)

/*
   Simplificando o CASE. A variavel tbtecla e' um vetor bidimensional
   que contem as teclas a serem testadas e suas respectivas acoes dentro
   do "code block" correspondente
*/
tbtecla={{K_LEFT,     {||op_edic:="A"}},;
         {K_RIGHT,    {||op_edic:="S"}},;
         {K_UP,       {||op_edic:="A"}},;
         {K_DOWN,     {||op_edic:="S"}},;
         {K_F9,       {||veoutros()}},;
         {K_ALT_F8,   {||rola_t:=.t.,ROLATELA()}},;
         {K_CTRL_PGDN,{||FIM_ARQ()}},;
         {K_CTRL_PGUP,{||INI_ARQ()}};
        }

EVAL(prgets)             // exibe tela e conteudo do registro
INFOSIS()                // exibe informacao no rodape' da tela
DO WHIL .t.
   SET CURS OFF
   cod_sos=sos_cod

   #ifdef COM_MOUSE
      tecl_p=MOUSETECLA()
      MOUSEGET(@li,@co)
      IF tecl_p=CLICK                                      // clicou botao esquerdo
         IF li<l_s.OR.co<c_s.OR.li>l_i.OR.co>c_i
            LOOP
         ENDI
         novapos=.t.
         KEYB CHR(77)              // coloca "M" no buffer para

         #ifdef COM_TUTOR
            tecl_p=IN_KEY(0)       // fazer lastkey() != de ESC
         #else
            tecl_p=INKEY(0)        // fazer lastkey() != de ESC
         #endi

      ENDI
   #else

      #ifdef COM_TUTOR

         #ifdef COM_REDE
            tecl_p=IN_KEY(drvtempo) // faz "refresh" da tela a cada drvtempo seg
         #else
            tecl_p=IN_KEY(0)        // aguarda usuario teclar algo
         #endi

      #else

         #ifdef COM_REDE
            tecl_p=INKEY(drvtempo)  // faz "refresh" da tela a cada drvtempo seg
         #else
            tecl_p=INKEY(0)         // aguarda usuario teclar algo
         #endi

      #endi

   #endi

   IF SETKEY(tecl_p)!=NIL           // se tecla digitada tem funcao programada
      EVAL(SETKEY(tecl_p))          // executa programacao
      tecl_p=0
   ENDI
   SET CURS ON                                        // acende o cursor
   op_edic=""
   nm=ASCAN(tbtecla,{|ve_a|tecl_p=ve_a[1]})           // procura tecla digitada no vetor tbtecla
   IF nm != 0                                         // se achou,
      EVAL(tbtecla[nm,2])                             // entao executa
   ELSEIF tecl_p=K_PGDN .AND.;                        // PgDn com scroll
          LEN(sistema[op_sis,O_TELA])>7
      IF MOV_PTR(sistema[op_sis,O_TELA,O_QTDE])=0
         ALERTA(2)                                    // encontrado o final do
         DBOX("* FINAL DO ARQUIVO *",15,,1)           // arquivo, vamos avisar
      ENDI
   ELSEIF tecl_p=K_PGUP .AND.;                        // PgUp com scroll
          LEN(sistema[op_sis,O_TELA])>7
      IF MOV_PTR(-1*sistema[op_sis,O_TELA,O_QTDE])=0
         ALERTA(2)                                    // encontrado o inicio do
         DBOX("* INICIO DO ARQUIVO *",15,,1)          // arquivo, vamos avisar
      ENDI
   ELSEIF tecl_p=K_PGDN .AND.;                        // PgDn p/ proxima tela
          sistema[op_sis,O_TELA,O_DEF]>1
      IF sistema[op_sis,O_TELA,O_ATUAL]<sistema[op_sis,O_TELA,O_DEF]
         sistema[op_sis,O_TELA,O_ATUAL]++
      ENDI
   ELSEIF tecl_p=K_PGUP .AND.;                        // PgDn p/ tela anterior
          sistema[op_sis,O_TELA,O_DEF]>1
      IF sistema[op_sis,O_TELA,O_ATUAL]>1
         sistema[op_sis,O_TELA,O_ATUAL]--
      ENDI
   ELSEIF tecl_p=K_ESC                                // cancelou
      EXIT
   ELSEIF tecl_p=K_F10                                // menu de opcoes
      op_edic=DBOX(msg_menu,2,67,E_MENU,,"MENU DE|EDIÄéO",,,AT(op_edic,tbmenu))
      op_edic=SUBS(" "+tbmenu,op_edic+1,1)
   ELSE
      IF tecl_p>0
         op_edic=UPPER(CHR(tecl_p))                   // converte tecla em letra
      ENDI
   ENDI
   IF AT(op_edic,"SA")=0 .AND. AT(op_edic,ALLTRIM(exrot[op_sis]))>0
      ALERTA()                                        // se usuario nao tem permissao,
      DBOX(msg_auto,,,3)                              // beep, beep, beep
      LOOP                                            // exibe mensagem e
   ENDI                                               // volta ao menu
   IF (EOF() .OR. BOF()) .AND. op_edic!="D" .AND. !EMPT(op_edic)
      msg="NÑo h† registros em "+;                    // arquivo vazio escolha ou
          ALLTRIM(sistema[op_sis,O_MENU])             // escolha diferente de inclusao
      ALERTA()                                        // 3 beeps
      DBOX(msg+", "+usuario)                          // para avisar
      LOOP                                            // espera digitar outra tecla
   ENDI

   DO CASE
      CASE op_edic="P"                                // procura registro
         POSI()

      CASE op_edic="S"                                // registro seguinte
         SKIP                                         // as formulas se existirem
         IF EOF()
            ALERTA(2)                                 // encontrado o final do
            DBOX("* FINAL DO ARQUIVO *",15,,1)        // arquivo, da mensagem e
            FIM_ARQ()                                 // posiciona no ultimo registro
         ENDI

      CASE op_edic="A"                                // registro anterior

         /*
            se inicio de arquivo ou, se ha filtro e nao atende, nao retrocede
            senao, retrocede um registro por vez
         */
         SKIP -1
         IF BOF().OR.IF(EMPTY(criterio),.f.,!&criterio.)
            ALERTA(2)                                 // encontrado o inicio do
            DBOX("* INICIO DO ARQUIVO *",15,,1)       // arquivo, da mensagem e
            INI_ARQ()                                 // posiciona no primeiro registro
         ENDI

      CASE op_edic="M"                                // modifica registro
         IF !(EOF() .OR. BOF())                       // registro excluido, nao pode ser alterado

            #ifdef COM_REDE
               IF !BLOREG(3,.5)                       // se nao conseguiu bloquear o
                  LOOP                                //  registro, volta ao menu
               ENDI
            #endi

            IF DELE()                                 // registro esta escluido
               ALERTA()                               // vamos avisar
               DBOX("REGISTRO EXCLU°DO",12,,1)

               #ifdef COM_MOUSE
                  novapos=.f.                         // cancela clique do mouse no campo
               #endi

            ELSE
               &prget1.(FORM_INVERSA)                 // processamento inverso, se houver
               &prget1.(INCLUI)                       // modif reg, com process dir, se houver

               #ifdef COM_MOUSE
                  novapos=.f.                         // cancela clique do mouse no campo
               #endi

            ENDI

            #ifdef COM_REDE
               UNLOCK                                 // libera registro
            #endi

            REGINICIO()                               // verifica se reg esta' no filtro
         ENDI

      CASE op_edic="D"                                // Inclusao de registros
         ord_dbf:=INDEXORD()                          // sava indice atual para incluirmos
         DBSETORDER(1)                                // sempre pelo indice principal
         &PrIncl.()                                   // chama programa de inclusao
         DBSETORDER(ord_dbf)                          // retorna ao indice da consulta
         REGINICIO()                                  // verifica se reg esta' no filtro

      CASE op_edic="E"                                // marca para exclusao

         #ifdef COM_REDE
            IF !BLOREG(3,.5)                          // se nao bloqueou o registro
               LOOP                                   // volta ao menu
            ENDI
         #endi

         IF !DELE()                                   // ja esta excluido?
            IF CONFEXCL()                             // pede para confirmar
               &prget1.(EXCLUI)                       // exclui e processo inverso
            ENDI
         ENDI

         #ifdef COM_REDE
            UNLOCK                                    // libera registro
         #endi

         DO WHILE !EOF() .AND. DELE() .AND.;          // acha o proximo
            SET(_SET_DELETED)                         // registro que nao
            SKIP                                      // esta excluido
         ENDD
         IF EOF()                                     // se for final do arquivo
            FIM_ARQ()                                 // forca eof()
         ENDI

      CASE op_edic="R"                                // recupera registro marcado

         #ifdef COM_REDE
            IF !BLOREG(3,.5)                          // tenta bloquear o registro
               LOOP
            ENDI
         #endi

         IF DELE()                                    // o registro esta excluido?
            &prget1.(RECUPERA)                        // recupera/processo direto, se houver
         ENDI

         #ifdef COM_REDE
            UNLOCK                                    // libera o registro
         #endi


      CASE op_edic="F"
         FILTRA(.t.,.t.)                              // filtra (indexando, ordenando)

      CASE op_edic="O"                                // ordena o arquivo
         cpord=""                                     // inicializa variavel
         CLASS(.t.)                                   // escolhe ordenacao

      CASE op_edic="G"                                // processamento global
         ultreg=RECN()                                // salva registro
         GLOBAL()                                     // prepara o processamento
         GO ultreg                                    // retorna ao registro anterior
         REGINICIO()                                  // verifica se reg esta' no filtro

   ENDC

   #ifdef COM_REDE
      IF op_edic!="S" .AND. op_edic!="A"
         COMMIT                                       // descarrega buffers
         GO RECNO()                                   // ajusta ponteiro
      ENDI
   #endi

   DISPBEGIN()
   EVAL(prgets)                                       // mostra registro que atende condicao
   INFOSIS()                                          // exibe informacao no rodape' da tela
   DISPEND()
ENDD
criterio:=cpord := ""                                 // reinicializa ordenacao e filtragem
SETKEY(K_CTRL_W,t_w)                                  // restaura teclas de controle
SETKEY(K_CTRL_R,t_r)
SETKEY(K_CTRL_C,t_c)
RETU

PROC REGINICIO()   // posiciona no 1 reg do filtro
IF &(INDEXKEY(0))!=IF(EMPT(criterio),"","T")+chv_1   // esta fora do filtro/relacao
   INI_ARQ()                                         // forca inicio do arquivo
ENDI
RETU

PROC INI_ARQ()   // inicio do arquivo
LOCAL ch_:=IF(EMPTY(criterio),"","T")+;     // monta expressao para achar
           IF(EMPTY(chv_rela),"",chv_1)     // 1o. registro do filtro/relacao
IF EMPTY(ch_)                               // nao tem filtro/relacao
   GO TOP                                   // vai para o 1o. reg do arquivo
ELSE                                        // senao,
   SEEK ch_                                 // acha o 1o. que atenda a expressao
ENDI
RETU

PROC FIM_ARQ()   // final do arquivo
LOCAL cr_:=IF(EMPT(criterio),"","T")
IF EMPTY(chv_2)                         // se nao estiver relacionado vai
   GO BOTT                              // para o ultimo reg do arquivo
ELSE                                    // caso contrario,
   SET SOFTSEEK ON                      // procura o ultimo registro
   SEEK cr_+chv_2                       // da relacao
   SET SOFTSEEK OFF                     // (desliga index mais proximo)
   SKIP -1                              // volta para dentro da relacao
   IF &(INDEXKEY(0))!=cr_+chv_1         // reg esta fora do filtro ou da
      GO BOTT                           // relacao, vai para o fimal
      SKIP                              // do arquivo real
   ENDI
ENDI
RETU

PROC IMP_FORM(f_)  // imprime formula na tela
LOCAL l_, c_
IF VALTYPE(f_[O_LINHA])="B"      // a linhas esta variando (scroll)
   l_=l_s+EVAL(f_[O_LINHA])      // acha a nova posicao
ELSE
   l_=l_s+f_[O_LINHA]            // a linha e fixa na tela
ENDI
c_=c_s+f_[O_COLUNA]              // coluna
@ l_,c_ SAY &(f_[O_FORM])        // exibe formula
RETU

PROC PEGACHV2()  // inicializa chv_1 e chv_2
IF !EMPTY(chv_rela)                       // se existe alguma relacao
   chv_1 = &chv_rela.                     // chv_1 contera a chave da relacao
   chv_2 = LEFT(chv_1,LEN(chv_1)-1)+;     // chv_2 sera o mais proximo
                           CHR(ASC(RIGHT(chv_1,1))+1)     // de chv_1
ELSE                                      // se nao existe relacao
   chv_1:=chv_2 := ""                     // inicializa vaiaveis
ENDI
RETU

PROC GLOBAL    // Processamento global de registros

/*
   dentro desta rotina, o usuario pode definir, em tempo de execucao,
   processamentos para alterar campos do arquivo. Nos comentarios a seguir
   nao confundir estes com os processamentos definidos em tempo de projeto
   da aplicacao, os quais sao aqui chamados de formulas direta e inversa
*/
LOCAL c_ampo:={}, exp_r:={}, cf_, a_ok, i:=0, getlist:={}, chv_x:="",;
      t_glob:=SAVESCREEN(0,0,MAXROW(),79), m_campos:="", dele_atu:=SET(_SET_DELETED)
PRIV cod_sos:=19

#ifdef COM_REDE
   IF !BLOARQ(3,.5)                                                 // tenta bloquear o arquivo
      RETU                                                          // se nao conseguiu, volta
   ENDI
#endi

ALERTA()
msg="Continuar processamento global|Cancelar a operaáÑo"
msgt=IF(EMPTY(criterio),"TODOS OS REGISTROS DO ARQUIVO!!!",;
        "SOMENTE OS REGISTROS FILTRADOS")
op=DBOX(msg,,,E_MENU,,"ATENÄéO, "+usuario+;                         // aviso importante!
        "!|ESTA ROTINA ATINGIRè|"+msgt+;
        "|ê ACONSELHAVEL FAZER 'BACKUP` ANTES!")
IF op!=1
   RETU                                                             // cancelou
ENDI
FOR i=1 TO FCOU()                                                   // enche m_campos com os titulos
   IF !("I"==sistema[op_sis,O_CAMPO,i,O_CRIT])                      // dos nomes dos campos do dbf
      m_campos+="|"+sistema[op_sis,O_CAMPO,i,O_TITU]                // excetos campos invisiveis
   ENDI
NEXT
m_campos=SUBS(m_campos,2)
op_o=1
msg="APAGA determinados registros|RECUPERA determinados registros|"+;
    "MODIFICA campos de determinados registros"
op_o=DBOX(msg,,,E_MENU,,"PROCESSAMENTO GLOBAL")                     // menu dos processamentos
IF op_o>0
   IF op_o=3                                                        // alteracao de campos
      DO WHIL LEN(c_ampo)<=FCOU()
         msg="PROCESSAMENTO GLOBAL|ESCOLHA O CAMPO PARA SER ALTERADO"
         op_1=DBOX(m_campos,,,E_MENU,,msg)
         IF op_1!=0
            ii=0
            FOR i=1 TO FCOU()                                       // acha campo escolhido
               IF !("I"==sistema[op_sis,O_CAMPO,i,O_CRIT])
                  ii++                                              // desprezando campos
               ENDI                                                 // invisiveis
               IF ii=op_1                                           // campo escolhido?
                  cp_=FIEL(i)                                       // nome do campo
                  msg=sistema[op_sis,O_CAMPO,i,O_CRIT]              // critica do campo
                  EXIT
               ENDI
            NEXT
            IF TYPE(cp_)="M".OR.UPPER(cp_)$UPPE(INDEXKEY(1));       // nega processamento em campos
               .OR. msg=="V" .OR. msg=="I"                          // memo, nao editavel, invisivel
               msg="NÑo permitido alterar campo|"+;                 // ou que seja parte da chave
                   "MEMO, INVIS°VEL, NéO EDITèVEL ou CHAVE"
               ALERTA(3)
               DBOX(msg,,,3,,"ATENÄéO! "+usuario)
               LOOP
            ENDI
            IF ASCAN(c_ampo,cp_)>0                                  // campo ja' tem um
               ALERTA(3)                                            // processamento definido
               DBOX("Campo j† foi selecionado",,,3,,"ATENÄéO! "+usuario)
               LOOP
            ENDI
            expg=SPAC(254)
            msg="A EXPRESSéO ABAIXO DEVERè OBEDECER A SINTAXE DA LINGUAGEM|*|"+;
                "F10=CAMPOS DO ARQUIVO|*|"+;
                "(Usar 'aspas' em constantes do tipo caracter)|*|"+;
                "Substituir "+cp_+" com"
            DO WHILE .t.
               SET KEY K_F10 TO ve_campos                           // f10 ve campos
               msgt="ALTERAÄéO DE CAMPO"
               expg=DBOX(msg,,,,,msgt,expg,"@S54")                  // capta processamento
               SET KEY K_F10 TO
               IF LASTKEY()=K_ESC                                   // cancelou
                  expg=""
               ELSEIF !CRIT("TYPE(expg)==TYPE(cp_)~"+;              // verifica se a expressao
                            "ExpressÑo ilegal!",15)                 // e do mesmo tipo do campo
                  LOOP                                              // se nao for, sobe
               ENDI
               EXIT
            ENDD
            IF !EMPT(expg)                                          // se nao cancelou,
               AADD(c_ampo,cp_)                                     // coloca o campo e a
               AADD(exp_r,ALLTRIM(expg))                            // a expressao nos arranjos
            ENDI
         ELSE
            EXIT                                                    // saindo...
         ENDI
      ENDD
   ENDI
   IF LEN(c_ampo)>0 .OR. op_o!=3                                    // existe processo
      msg="Apaga   RecuperaAltera"                                  // mglob=nome do processo
      mglob=TRIM(SUBS(msg,op_o*8-7,8))                              // que foi escolhido
      ALERTA(2)
      op_g=2
      msg="Confirma a cada registro|"+mglob+" sem confirmar"
      op_g=DBOX(msg,,,E_MENU,,UPPER(mglob))                         // confirmar ou nao?
      IF op_g=0

         #ifdef COM_REDE
            UNLOCK                                                  // desbloqueia o arquivo
         #endi

         RETU
      ELSE
         cf_=(op_g=1)                                               // cf_=.t., tem confirmacao
         getsx=LEFT(ALIAS(),3)+"_gets"
         get1x=LEFT(ALIAS(),3)+"_get1"
         SET DELE OFF                                               // excluidos serÑo vistos
         IF !cf_                                                    // nao confirmado
            DBOX("Aguarde! ESC cancela",,,,NAO_APAGA)
         ELSEIF brw                                                 // se veio da EDITA()
            CBC1(.t.)
            IF sistema[op_sis,O_TELA,O_DEF]>1                       // se o subsistema tem
               SET KEY K_CTRL_R TO tela_ant                         // mais de uma tela,
               SET KEY K_CTRL_C TO tela_seg                         // habilita PGDN e PGUP
            ENDI
         ENDI
         INI_ARQ()                                                  // posiciona no inicio do arquivo

         #ifdef COM_TUTOR
            DO WHIL !EOF() .AND. IN_KEY()!=K_ESC                    // correndo o arquivo
         #else
            DO WHIL !EOF() .AND. INKEY()!=K_ESC                     // correndo o arquivo
         #endi

            IF cf_                                                  // se metodo confirmado
               DISPBEGIN()
               &getsx.()                                            // conteudo do registro
               DISPEND()
               ALERTA(1)                                            // beep!
               volta=0
               msg=mglob+"|NÑo "+mglob+"|Cessa confirmaáÑo|Cancela"
               op_g=DBOX(msg,0,2,E_MENU,,,,"SELECIONE",2)           // oferece confirmacao
               IF volta>0                                           // volta>0 significa que
                  sistema[op_sis,O_TELA,O_ATUAL]++                  // teclou PGDN ou PGUP
                  LOOP                                              // incrementa tela e sobe
               ENDI
               IF op_g=0 .OR. op_g=4                                // cancelou
                  EXIT
               ENDI
               a_ok=(op_g!=2)                                       // a_ok=.t., pode processar!
               cf_=(op_g!=3)                                        // se cf_=.t., quer continuar
               IF !cf_                                              // confirmando os processos
                  DBOX("Aguarde!  ESC cancela",,,,NAO_APAGA)
               ENDI
            ELSE                                                    // metodo nao confirmado,
               a_ok=.t.
            ENDI
            IF a_ok                                                 // vamos fazer o processo global

               IF op_o=1                                            // excluindo
                  IF !DELE()                                        // (so se nao apagado)
                     &get1x.(EXCLUI)                                // executa formula inversa,
                  ENDI                                              // se existir e marca para apagar

               ELSEIF op_o=2                                        // recuperando
                  IF DELE()                                         // (so os marcados)
                     &get1x.(RECUPERA)                              // executa formula direta e
                  ENDI                                              // desmarca o apagamento

               ELSEIF !DELE()                                       // alterando campos
                  &get1x.(FORM_INVERSA)                             // executa formula inversa
                  SKIP                                              // vamos salvar o prox registro
                  proxreg=IF(EOF(),-1,RECN())                       // se estivermos alterando campo do
                  SKIP -1                                           // componente do filtro ou ordenacao
                  FOR i=1 TO LEN(c_ampo)                            // modifica os campos
                     REPL &(c_ampo[i]) WITH &(exp_r[i])             // que foram escolhidos
                  NEXT
                  &get1x.(FORM_DIRETA)                              // executa a formula direta
                  IF proxreg>0                                      // se nao for final do arquivo,
                     GO proxreg                                     // reposiciona no proximo
                     SKIP -1                                        // registro a ser alterado
                  ELSE                                              // senao,
                     GO BOTT                                        // forca fim do arquivo
                  ENDI
               ENDI

            ENDI
            SKIP                                                    // o proximo por favor...
            IF &(INDEXKEY(0))!=IF(EMPT(criterio),"","T")+chv_1      // esta fora do filtro ou relacao
               EXIT                                                 // acabou o processo global
            ENDI
         ENDD
         IF op_menu=PROJECOES                                       // se veio da EDITA() ve
            IF sistema[op_sis,O_TELA,O_DEF]>1                       // se o subsistema tem
               SET KEY K_CTRL_R TO                                  // mais de uma tela para
               SET KEY K_CTRL_C TO                                  // desabilita PGDN e PGUP
            ENDI
         ENDI
         RESTSCREEN(0,0,MAXROW(),79,t_glob)                         // restaura tela
         DISPBEGIN()                                                // escreve sem mostrar
         &getsx.()                                                  // conteudo do registro
         DISPEND()                                                  // mostra o que escreveu
      ENDI
   ENDI
ENDI

#ifdef COM_REDE
   UNLOCK                                                           // libera arquivo
#endi

SET(_SET_DELETED,dele_atu)                                          // retorna visibilidade
RETU

PROC VE_REL()  // ve relatorio gravado em disco
PRIV cod_sos, cur_sor:=SETCURSOR(3)    // salva cursor/acende
SAVE SCREEN                            // salva tela
arq_=ARQGER()                          // pega nome do arquivo
IF !EMPTY(arq_)                        // se cancelou ou nao informou
   cod_sos=1
   BROWSE_REL(arq_,2,3,MAXROW()-2,78)  // mostra o arquivo gravado
ENDI
REST SCREEN                            // restaura a tela
SETCURSOR(cur_sor)                     // restabelece o cursor
RETU

PROC HELP    // Apresenta ajuda on-line
LOCAL tela_, txt, ctr, t, cor_, qdlin_, linf_, estr_db, pg_up, pg_dn,;
      tec_f3, tec_f4, tec_f9, tec_f8
SETKEY(K_F1,NIL)                                       // evita recursividade
pg_up =SETKEY(K_PGUP,NIL)                              // desabilita PgUp,
pg_dn =SETKEY(K_PGDN,NIL)                              // PgDn,
tec_f3=SETKEY(K_F3,NIL)                                // F3,
tec_f4=SETKEY(K_F4,NIL)                                // F4,
tec_f9=SETKEY(K_F9,NIL)                                // F9 e
tec_f8=SETKEY(K_ALT_F8,NIL)                            // ALT-F8
tela_=SAVESCREEN(0,0,MAXROW(),79)                      // salva a tela por baixo e
cor_=SETCOLOR(drvtithlp)                               // o esquema de cor vigente
IF !FILE(arq_sos)                                      // nao ha texto de ajuda...
   ALERTA()                                            // beep beep beep
   DBOX("O arquivo "+arq_sos+"|contendo o texto de "+;
        "ajuda|nÑo foi encontrado",,,2,,"ATENÄéO,"+;   // avisa!
        usuario)
ELSE
   txt=LEMANU(arq_sos,cod_sos)                         // pega bloco de ajuda
   qdlin_=MLCOUNT(txt,56)                              // qde linhas
   maxlt_ =MAXROW()
   linf_ =IF(qdlin_>maxlt_-7,maxlt_-3,qdlin_+3)        // calcula linha inferior
   CAIXA(mold,2,10,linf_,69,392)                       // monta janela
   ctr=IF(qdlin_>maxlt_-6," "+CHR(K_CTRL_X)+" "+;      // monta teclas de controle
          CHR(K_CTRL_Y)+" PgUp PgDn","")+" ESC "       // disponiveis na janela
   @ linf_,(80-LEN(ctr))/2 SAY ctr                     // mostra teclas de controle
   SETCOLOR(drvcorhlp)

   #ifdef COM_TUTOR
      MEMOEDIT(txt,3,12,linf_-1,68,.f.,"mHelp")          // mostra o bloco de ajuda
   #else
      MEMOEDIT(txt,3,12,linf_-1,68,.f.)                  // mostra o bloco de ajuda
   #endi

ENDI
SETCOLOR(cor_)
RESTSCREEN(0,0,MAXROW(),79,tela_)
SETKEY(K_PGUP,pg_up)                                   // habilita teclas PgUp,
SETKEY(K_PGDN,pg_dn)                                   // PgDn,
SETKEY(K_F3,tec_f3)                                    // F3,
SETKEY(K_F4,tec_f4)                                    // F4,
SETKEY(K_F9,tec_f9)                                    // F9 e
SETKEY(K_ALT_F8,tec_f8)                                // ALT-F8
SET KEY K_F1 TO help                                   // habilita F1
RETU


#ifdef COM_TUTOR
   PROC mHelp  // grava/le teclas do tutorial
   PRIV  t_:=LASTKEY()                          // tecla digitado no help
   IF acao_mac $ "Gg"                           // se esta gravando macro
      KEYB_MAC(MONTA_BUFF(t_))                  // joga no buffer do teclado
      Q_TEC(0)                                  // para gravar a tecla
   ELSEIF acao_mac $ "LAC" .AND. t_!=K_ESC      // se esta lendo
      KEYB_MAC(MONTA_BUFF(Q_TEC(0)))            // le a tecla e joga no buffer
   ENDI                                         // do teclado
   RETURN
#endi


PROC NADAFAZ  // desativa ^W/PgUp/PgDn em inclusao
RETU

PROC INFOSIS  // coloca informacao no rodape' da tela
LOCAL co_r:=SETCOLOR(drvcorenf)
Para MsgEsq, MsgCen, MsgDir
If Empty(MsgEsq)
IF op_menu=INCLUSAO                                 // teclas disponiveis na
   MsgEsq="Inclui"                                  // inclusao
   MsgCen="[F3] Repetir, [F4] Confirmar, [F9] Outros Arquivos"
ELSEIF op_menu=ALTERACAO                            // teclas disponiveis na
   MsgEsq="Altera"                                  // alteracao
   MsgCen="[F9] Outros Arquivos, [F10] Menu"
ELSE                                                // teclas disponiveis na
   MsgEsq="Ve Global"                               // ve global da func EDITA()
   MsgCen=gcr
ENDI
IF sistema[op_sis,O_TELA,O_DEF]>1                // tem varias telas?
   MsgCen+=IF(sistema[op_sis,O_TELA,O_ATUAL]<sistema[op_sis,O_TELA,O_DEF].AND.;
              op_menu!=INCLUSAO," PgDn","";
           )
   MsgCen+=IF(sistema[op_sis,O_TELA,O_ATUAL]>1," PgUp","")
ENDI

#ifdef COM_MOUSE
   IF drvmouse .AND. op_menu=ALTERACAO              // teclas do mouse
      MsgCen+=" "+CHR(27)+" "+CHR(26)
   ENDI
#endi
EndIf
IF op_menu=INCLUSAO                                 // flags de repeticao e
   MsgDir=IF(fgrep," Rep",SPAC(4))+;                // confirmacao na inclusao
          IF(drvconf," Conf",SPAC(5))
ELSEIF DELE() .AND. EMPTY(READVAR())                // coloca msg de EXCLUIDO
   MsgDir=" EXCLUIDO"                               // se for o caso...
ELSE
   MsgDir=SPACE(9)
ENDI
@ 24,00 SAY " "+MsgEsq+PADC(MsgCen,79-LEN(MsgEsq)-LEN(MsgDir))+MsgDir+" "
SETCOLOR(co_r)
RETU

PROC TELA_ANT  // Prepara volta para tela anterior (PgUp)
IF sistema[op_sis,O_TELA,O_ATUAL]>1        // se for a da primeira tela,
   sistema[op_sis,O_TELA,O_ATUAL]-=2       // decrementa em dois e forca
   KEYB CHR(K_ESC)                         // saida com ESC
   volta=1                                 // volta=1 indica ao chamador
ENDI                                       // que pressionou PGUP
RETU

PROC TELA_SEG  // Prepara o avanco para a tela seguinte (PgDn)
IF sistema[op_sis,O_TELA,O_ATUAL]<sistema[op_sis,O_TELA,O_DEF]   // se nao estiver na ultima tela,
   KEYB CHR(K_ESC)                         // forca ESC para sair
   volta=2                                 // volta=2 indica ao chamador
ENDI                                       // que pressionou PGDN
RETU

PROC TIRA_LANC(db_,lan_,for_inv_)  // Retira o lancamento feito no arquivo alvo
LOCAL ar_:=ALIAS(), prg_:=LEFT(db_,3)+"_get1", in_:=1, ord_
for_inv_=IF(for_inv_=NIL,.t.,for_inv_)
IF !EMPTY(SELECT(db_))                               // se o arquiov ja esta aberto
   SELE (db_)                                        // salva a ordem do indice
   in_=INDEXORD()                                    // atual
ENDI
ord_=LEN(sistema[EVAL(qualsis,db_),O_CHAVE])         // ultimo indice do dbf (ind lancamento)
IF PTAB(lan_,db_,ord_,.t.)                           // procura o 1o. que existe
   SELE (db_)
   WHILE !EOF() .AND. codlan=lan_                    // para todos os registros do lancamento

      #ifdef COM_REDE
         BLOREG(0,.5)                                // bloqueia para sempre
      #endi

      IF for_inv_
         &prg_.(FORM_INVERSA)
      ELSE
         DELE
      ENDI

      #ifdef COM_REDE
         UNLOCK                                      // libera registro
      #endi

      SKIP                                           // proximo registro
   ENDD
ENDI
DBSETORDER(in_)                                      // retorna p/ o indice atual
IF !EMPTY(ar_)
   SELE (ar_)
ELSE
   SELE 0
ENDI
RETU

PROC FAZ_LANC(db_,lan_,com_seq)  // realiza lancamentos em arquivos
LOCAL ar_:=ALIAS()

#ifdef COM_REDE
   PRIV  s_cria, s_gera, s_grava, s_arqu
#else
   PRIV  s_gera, s_grava
#endi

com_seq:=IF(com_seq=NIL,.f.,com_seq)
SELE (db_)                              // seleciona dbf alvo do lancamento
IF com_seq                              // existe cp sequencial?

   #ifdef COM_REDE
      s_cria=LEFT(db_,3)+"_CRIA_SEQ"    // prg que cria XXX_seq.dbf
      s_arqu=LEFT(db_,3)+"_SEQ"         // nome arq sequencial
   #endi

   s_gera=LEFT(db_,3)+"_GERA_SEQ"       // prg que gera campo sequencial
   s_grava=LEFT(db_,3)+"_GRAVA_SEQ"     // prg que grava campo no arquivo
   FOR i=1 TO FCOU()                    // cria/declara privadas as
      msg=FIEL(i)                       // variaveis de memoria com
      PRIV &msg.                        // o mesmo nome dos campos
   NEXT                                 // do arquivo
ENDI

#ifdef COM_REDE
   IF com_seq .AND. EOF()               // se o dbf tem campo sequencial
      &s_cria.()                        // e vai criar um registro novo
      SELE (db_)                        // cria/seleciona dbf de controle
      &s_gera.()                        // e gera os sequenciais...
   ELSE                                 // caso contrario
      com_seq=.f.                       // desabilita cp sequencial
   ENDI
   DO WHIL .t.
      IF EOF()                          // se for final do arquivo
         APPE BLAN                      // cria um novo registro
      ELSE
         BLOREG(0,.5)                   // bloqueia o registro
      ENDI
      IF NETERR()                       // erro...
         DBOX(ms_uso,20)                // mensagem ao usuario
         LOOP                           // e tenta novamente
      ENDI
      EXIT
   ENDD
#else
   IF EOF()                             // e final de arquivo
      IF com_seq                        // se o dbf tem campo sequencial
         &s_gera.()                     // gera os campos...
      ENDI
      APPE BLAN                         // cria um novo registro
   ELSE
      com_seq=.f.
   ENDI
#endi

IF DELE()                               // registro excluido?
   RECA                                 // recupera-o
ENDI
REPL codlan WITH lan_                   // atualiza o codigo do lancamento
IF com_seq                              // tem sequencial entao
   &s_grava.()                          // grava no arquivo

   #ifdef COM_REDE
      SELE (s_arqu)
      UNLOCK                            // libera DBF para outros usuarios
      COMMIT                            // atualiza cps sequenciais no disco
   #endi

ENDI
IF !EMPTY(ar_)                          // se existia dbf aberto na area
   SELE (ar_)                           // inicial, vamos seleciona-los
ELSE                                  // caso contrario
   SELE 0                               // pega a primeira area livre
ENDI
RETU

PROC ERRORSYS()   // Mensagem de erro durante a execucao da aplicacao
ERRORBLOCK({|erro| ERROMSG(erro)})
RETU

* \\ Final de SFI_PROC.PRG
