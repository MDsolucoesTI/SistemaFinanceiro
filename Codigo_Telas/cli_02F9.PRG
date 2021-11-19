/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho
 \ Programa: PES_02F9.PRG
 \ Data....: 02-01-96
 \ Sistema.: Sistema Financeiro
 \ Funcao..: F¢rmula (comreg) a mostrar na tela de PESSOA
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "sfin.ch"    // inicializa constantes manifestas
Parameters mEstCiv
Local mResp

Do Case
   Case mEstCiv = '1'
      mResp = 'Solteiro   '
   Case mEstCiv = '2'
      mResp = 'Casado    '
   Case mEstCiv = '3'
      mResp = 'Viuvo     '
   Case mEstCiv = '4'
      mResp = 'Separado  '
   Case mEstCiv = '5'
      mResp = 'Divorciado'
   Case mEstCiv = '6'
      mResp = 'Amasiado  '
EndCase

RETU mResp      // <- deve retornar um valor qualquer

* \\ Final de PES_02F9.PRG
