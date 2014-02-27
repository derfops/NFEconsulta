#!/bin/sh
# SCRIPT CONSULTA O STATUS DO SERVICO DE NFE DIRETAMENTE DA RECEITA FEDERAL
# VERSAO 0.1
# AUTOR CARLOS EDUARDO (DERFOPS@GMAIL.COM)
# DISPONIVEL EM https://github.com/derfops/NFEconsulta
# SCRIPT FEITO BASEADO NO AUTORIZADOR SVRS

# VARIAVEIS
CURL=$(which curl)
AWK=$(which awk)
CAT=$(which cat)
EGREP=$(which egrep)
LINK="http://www.nfe.fazenda.gov.br/portal/disponibilidade.aspx?versao=2.00&tipoConteudo=Skeuqr8PQBY="
ARQUIVO_TEMPORARIO="/tmp/statusNFE.txt"

# DOWNLOAD
$CURL -s -o $ARQUIVO_TEMPORARIO "$LINK"

# SVRS (ALTERE DE ACORDO COM O SEU AUTORIZADOR)
# 
SVRS=$($CAT $ARQUIVO_TEMPORARIO | $EGREP "<td>SVRS</td>")
STATUS_RECEPCAO=$(echo $SVRS | $AWK -F '<img src="' '{print $2}' | $AWK -F '"' '{print $1}')
STATUS_RETORNO_RECEPCAO=$(echo $SVRS | $AWK -F '<img src="' '{print $3}' | $AWK -F '"' '{print $1}')
STATUS_INUTILIZACAO=$(echo $SVRS | $AWK -F '<img src="' '{print $4}' | $AWK -F '"' '{print $1}')
STATUS_CONSULTA_PROTOCOLO=$(echo $SVRS | $AWK -F '<img src="' '{print $5}' | $AWK -F '"' '{print $1}')
STATUS_SERVICO=$(echo $SVRS | $AWK -F '<img src="' '{print $6}' | $AWK -F '"' '{print $1}')
STATUS_CONSULTA_CADASTRO=$(echo $SVRS | $AWK -F '<img src="' '{print $7}' | $AWK -F '"' '{print $1}')
STATUS_RECEPCAO_EVENTO=$(echo $SVRS | $AWK -F '<img src="' '{print $8}' | $AWK -F '"' '{print $1}')
STATUS_AUTORIZACAO=$(echo $SVRS | $AWK -F '<img src="' '{print $9}' | $AWK -F '"' '{print $1}')
STATUS_RETORNO_AUTORIZACAO=$(echo $SVRS | $AWK -F '<img src="' '{print $10}' | $AWK -F '"' '{print $1}')

function consultar_servico() {
	[ $2 == "imagens/bola_verde_P.png" ] && echo "$1 = ONLINE"
	[ $2 == "imagens/bola_amarela_P.png" ] && echo "$1 = INDISPONIVEL"
	[ $2 == "imagens/bola_vermelho_P.png" ] && echo "$1 = OFFLINE"
}

consultar_servico "RECEPCAO" $STATUS_RECEPCAO
consultar_servico "RETORNO RECEPCAO" $STATUS_RETORNO_RECEPCAO
consultar_servico "INUTILIZACÃO" $STATUS_INUTILIZACAO
consultar_servico "CONSULTA PROTOCOLO" $STATUS_CONSULTA_PROTOCOLO
consultar_servico "SERVICO" $STATUS_SERVICO
consultar_servico "CONSULTA CADASTRO" $STATUS_CONSULTA_CADASTRO
consultar_servico "RECEPCAO EVENTO" $STATUS_RECEPCAO_EVENTO
consultar_servico "AUTORIZACAO" $STATUS_AUTORIZACAO
consultar_servico "RETORNO AUTORIZACAO" $STATUS_RETORNO_AUTORIZACAO
