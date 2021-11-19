/*
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
 \ Empresa.: Denny Paulista Azevedo Filho - Consultoria & Multim¡dia
 \ Programa: PES_03F9.PRG
 \ Data....: 02-01-96
 \ Sistema.: Sistema Financeiro
 \ Funcao..: F¢rmula (comreg) a mostrar na tela de PESSOA
 \ Analista: Denny Paulista Azevedo Filho
 \ Criacao.: Programado manualmente pelo analista
 \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
*/

#include "sfin.ch"    // inicializa constantes manifestas

Parameters mRegCas
Local mResp

Do Case
   Case mRegCas = '1'
      mResp = 'Comunh„o Parcial'
   Case mRegCas = '2'
      mResp = 'Comunh„o        '
   Case mRegCas = '3'
      mResp = 'Separa‡„o       '
EndCase

RETU mResp      // <- deve retornar um valor qualquer

* \\ Final de PES_03F9.PRG
