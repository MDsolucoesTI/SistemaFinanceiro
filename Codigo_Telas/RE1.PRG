/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: RE1.PRG
 \ Data....: 27-02-96
 \ Sistema.: Sistema Financeiro
 \ Funcao..: Tela complementar do subsistema de baixa de recibos
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: GAS-Pro v2.0 e modificado pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/
#include "sfin.ch"    // inicializa constantes manifestas

PARA lin_menu,col_menu
PRIV op_sis, tela_fundo:=SAVESCREEN(0,0,MAXROW(),79)
op_sis=EVAL(qualsis,"RECIBO")
IF nivelop<1                                                 // se usuario nao tem permissao,
   ALERTA()                                                  // entao, beep, beep, beep
   DBOX(msg_auto,,,3)                                        // lamentamos e
   RETU                                                      // retornamos ao menu
ENDI
cn:=fgrep :=.f.
criterio=""
SELE A                                                       // e abre o arquivo e seus indices

#ifdef COM_REDE
   IF !USEARQ(sistema[op_sis,O_ARQUI],.f.,20,1)              // se falhou a abertura do
      RETU                                                   // arquivo volta ao menu anterior
   ENDI
#else
   USEARQ(sistema[op_sis,O_ARQUI])
#endi

SET KEY K_F9 TO veoutros                                     // habilita consulta em outros arquivos
IF AT("D",exrot[op_sis])=0                                   // se usuario pode fazer inclusao
   RE1_INCL()                                                // neste arquivo chama prg de inclusao
ELSE                                                         // caso contrario vamos avisar que
   ALERTA()                                                  // ele nao tem permissao para isto
   DBOX(msg_auto,,,3)
ENDI
SET KEY K_F9 TO                                              // F9 nao mais consultara outros arquivos
CLOS ALL                                                     // fecha todos arquivos abertos
RETU

PROC RE1_incl     // inclusao no arquivo RECIBO
LOCAL getlist:={}, cabem:=1, ult_reg:=RECN(),;
      ctl_r, ctl_c, ctl_w, t_f4_, dele_atu:=SET(_SET_DELETED,.f.)
PRIV op_menu:=TEL_EXTRA, blk_recibo:=.t., tem_borda, criterio:="", cpord:=""
t_f4_=SETKEY(K_F4,{||conf()})                                // confirma campos com ENTER
ctl_w=SETKEY(K_CTRL_W,{||nadafaz()})                         // enganando o CA-Clipper...
ctl_c=SETKEY(K_CTRL_C,{||nadafaz()})
ctl_r=SETKEY(K_CTRL_R,{||nadafaz()})
l_a=0
DO WHIL cabem>0
   cod_sos=6
   sistema[op_sis,O_TELA,O_ATUAL]=1                          // primeira tela...
   rola_t=.f.                                                // flag se quer rolar a tela
   SELE RECIBO
   GO BOTT                                                   // forca o
   SKIP                                                      // final do arquivo
   
   /*
      cria variaveis de memoria identicas as de arquivo, para inclusao
      de registros
   */
   FOR i=1 TO FCOU()
      msg=FIEL(i)
      M->&msg.=&msg.
   NEXT
   DISPBEGIN()                                               // apresenta a tela de uma vez so
   RE1_TELA()
   INFOSIS()                                                 // exibe informacao no rodape' da tela
   DISPEND()
   SELE 0                                                    // torna visiveis variaveis de memoria
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   SET KEY K_ALT_F8 TO ROLATELA
   
   /*
      recebe chaves do arquivo de indice basico
   */
   @ l_s+04 ,c_s+04 GET  sequen;
                    PICT sistema[op_sis,O_CAMPO,01,O_MASC]
                    DEFINICAO 1

   READ
   SET KEY K_ALT_F8 TO
   IF rola_t
      ROLATELA(.f.)
      LOOP
   ENDI
   SELE RECIBO
   IF LASTKEY()=K_ESC                                        // cancelou ou chave em branco
      cabem=0                                                // prepara saida da inclusao
      LOOP                                                   // volta p/ menu de cadastramento
   ENDI
   SEEK STR(M->sequen,09,00)
   IF !FOUND() .OR. DELE()                                   // se nao encontrou ou esta
      ALERTA()                                               // excluido, avisa e volta
      DBOX("REGISTRO NAO ENCONTRADO OU EXCLUIDO",12,,1)      // para receber nova chave
      LOOP
   ENDI

   #ifdef COM_REDE
      IF !BLOREG(3,.5)                                       // se nao conseguiu bloquear o
         LOOP                                                // registro, volta ao menu
      ENDI
   #endi

   FOR i=1 TO FCOU()                                         // inicializa variaveis
      msg=FIEL(i)                                            // de memoria com o mesmo
      M->&msg.=&msg.                                         // valor valor dos campos
   NEXT                                                      // do arquivo
   SELE 0
   RE1_GET1()                                                // modificando o registro
   SELE RECIBO
   IF LASTKEY()!=K_ESC                                       // se nao cancelou modificacoes
      FOR i=1 TO FCOU()                                      // para cada campo,
         msg=FIEL(i)                                         // salva o conteudo
         REPL &msg. WITH M->&msg.                            // da memoria no arquivo
      NEXT
   ENDI

   #ifdef COM_REDE
      UNLOCK                                                 // libera registro
   #endi

ENDD
GO ult_reg                                                   // para o ultimo reg digitado
SETKEY(K_F4,t_f4_)
SET(_SET_DELETED,dele_atu)                                      // ecluidos visiveis/invisiveis
SETKEY(K_CTRL_W,ctl_w)
SETKEY(K_CTRL_C,ctl_c)
SETKEY(K_CTRL_R,ctl_r)
RETU

PROC RE1_tela     // tela do arquivo RECIBO
tem_borda=.f.
l_s=0                                     // coordenadas da tela
c_s=5
l_i=24
c_i=76
SETCOLOR(drvtittel)
vr_memo=NOVAPOSI(@l_s,@c_s,@l_i,@c_i)     // pega posicao atual da tela
CAIXA(SPAC(8),l_s+1,c_s+1,l_i,c_i-1)      // limpa area da tela/sombra
SETCOLOR(drvcortel)
@ l_s+01,c_s+1 SAY "ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ Baixa de Recibos ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ"
@ l_s+03,c_s+1 SAY " ฺ Sequencia ย Pasta ย Nฃmero ย Venc Contrato ย Periodo ฤฤฤฤฤฤฤฤฤฤฤฤฟ"
@ l_s+04,c_s+1 SAY " ณ           ณ       ณ        ณ               ณ          a          ณ"
@ l_s+05,c_s+1 SAY " ร Locat rio มฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด"
@ l_s+06,c_s+1 SAY " ณ          -                                                       ณ"
@ l_s+07,c_s+1 SAY " ร Fiador ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด"
@ l_s+08,c_s+1 SAY " ณ          -                                                       ณ"
@ l_s+09,c_s+1 SAY " ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู"
@ l_s+10,c_s+1 SAY " ษอ At :          อออออออออออออออัออ Apขs :          ออออออออออออออป"
@ l_s+11,c_s+1 SAY " บ Aluguel.......:                ณ Aluguel.......:                 บ"
@ l_s+12,c_s+1 SAY " บ IPTU..........:                ณ IPTU..........:                 บ"
@ l_s+13,c_s+1 SAY " บ Agua..........:                ณ Agua..........:                 บ"
@ l_s+14,c_s+1 SAY " บ Luz...........:                ณ Luz...........:                 บ"
@ l_s+15,c_s+1 SAY " บ Telefone......:                ณ Telefone......:                 บ"
@ l_s+16,c_s+1 SAY " บ Outros........:                ณ Outros........:                 บ"
@ l_s+17,c_s+1 SAY " บ                                ณ Clausula 20...:                 บ"
@ l_s+18,c_s+1 SAY " บ                                ณ Correo......:                 บ"
@ l_s+19,c_s+1 SAY " วฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤถ"
@ l_s+20,c_s+1 SAY " บ Total.........:                ณ Total.........:                 บ"
@ l_s+21,c_s+1 SAY " ฬออออออออออออออออออออออออออออออออฯอออออออออออออออออออออออออออออออออน"
@ l_s+22,c_s+1 SAY " บ Valor Pago :                     Data Pagamento :                บ"
@ l_s+23,c_s+1 SAY " ศออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ"
RETU

PROC RE1_gets     // mostra variaveis do arquivo RECIBO
LOCAL getlist := {}
RE1_TELA()
SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
PTAB(STR(PASTA,04,00),'ALUGUEL',1)
CRIT("",,"8|9|10|11|12|13|15|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34")
@ l_s+04 ,c_s+04 GET  sequen;
                 PICT sistema[op_sis,O_CAMPO,01,O_MASC]

@ l_s+22 ,c_s+17 GET  pagval;
                 PICT sistema[op_sis,O_CAMPO,23,O_MASC]

@ l_s+22 ,c_s+54 GET  datpag;
                 PICT sistema[op_sis,O_CAMPO,24,O_MASC]

CRIT("",,"14|16")
CLEAR GETS
RETU

PROC RE1_get1     // capta variaveis do arquivo RECIBO
LOCAL getlist := {}
DO WHILE .t.
   rola_t=.f.
   SET KEY K_ALT_F8 TO ROLATELA
   SETCOLOR(drvcortel+","+drvcorget+",,,"+corcampo)
   CRIT("",,"8|9|10|11|12|13|15|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34")
   @ l_s+22 ,c_s+17 GET  pagval;
                    PICT sistema[op_sis,O_CAMPO,23,O_MASC]
                    DEFINICAO 23

   @ l_s+22 ,c_s+54 GET  datpag;
                    PICT sistema[op_sis,O_CAMPO,24,O_MASC]
                    DEFINICAO 24

   READ
   SET KEY K_ALT_F8 TO
   IF rola_t
      ROLATELA(.f.)
      LOOP
   ENDI
   EXIT
ENDD
RETU

* \\ Final de RE1.PRG
