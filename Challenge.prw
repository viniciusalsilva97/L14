#INCLUDE 'TOTVS.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'FWMVCDEF.CH'

#DEFINE POSICAOCODIGO 1
#DEFINE POSICAODESC   2
#DEFINE POSICAOTIPO   3
#DEFINE POSICAOUM     4
#DEFINE POSICAOPRECO  5
#DEFINE POSICAOATIVO  6

/*/{Protheus.doc} User Function L14C
    Importar um arquivo csv para o Protheus
    @type  Function
    @author Vinicius Silva
    @since 06/05/2023
    @see https://tdn.totvs.com/display/tec/tFileDialog
    @see https://tdn.totvs.com/display/public/framework/FWFileReader
    @see https://tdn.totvs.com/display/tec/StrTokArr
    @see https://tdn.totvs.com/pages/releaseview.action?pageId=566489232
    @see https://tdn.totvs.com/display/tec/At
    @see https://tdn.totvs.com/display/tec/StrTran
    /*/
User Function L14C()
    Private cArquivoCsv := ""

    //? Função responsável por permitir a escolha do arquivo csv
    cArquivoCsv := tFileDialog("Arquivo CSV (*.csv)", "Escolha o arquivo", , , .F.,) 

    ImportaProdutos()
Return 

Static Function ImportaProdutos()
    Local cCod, cAtivo, cDesc, cTipo, cUm, cPreco  
    Local aArea        := GetArea()
    Local cLinhaAtual  := ""
    Local lCabecalho   := .T.
    Local aCabecalho   := {}
    Local aConteudo    := {}

    //? Indica qual arquivo será lido
    Local oArquivo := FWFileReader():New(cArquivoCsv)

    Private lMsErroAuto := .F.
    Private oModel      := NIL

    PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' MODULO 'COM'

    oModel := FwLoadModel('MATA010')
    oModel:SetOperation(MODEL_OPERATION_INSERT)
    oModel:Activate()
    oArquivo:Open()

    DbSelectArea('SB1')

    While (oArquivo:HasLine())
        //? Pega a  linha atual
        cLinhaAtual := oArquivo:GetLine()

        //? Verifica se a linha atual é o cabeçalho ou o conteúdo do arquivo  e transforma em array
        if lCabecalho
            //? Considera que a primeira linha é o cabeçalho
            aCabecalho := StrTokArr(cLinhaAtual, ",")
            lCabecalho := .F.
        else
            //? Tratamentos p/ a descrição do produto
            cLinhaAtual := StrTran(cLinhaAtual, 'MB'   , '') //? Substitui uma string por outra
            cLinhaAtual := StrTran(cLinhaAtual, 'C/1'  , '')
            cLinhaAtual := StrTran(cLinhaAtual, 'CINTA', '')
            cLinhaAtual := StrTran(cLinhaAtual, 'AM'   , '')
            cLinhaAtual := StrTran(cLinhaAtual, 'PM'   , '')
            cLinhaAtual := StrTran(cLinhaAtual, 'IND'  , '')
            cLinhaAtual := StrTran(cLinhaAtual, 'GD'   , '')

            //? Retorna a posição da string pesquisada e retorna zero se não tiver a string
            while At('"', cLinhaAtual) > 0
                cLinhaAtual := StrTran(cLinhaAtual, '"' , '')
            end

            aConteudo := StrTokArr(cLinhaAtual, ",")
            cCod      := aConteudo[POSICAOCODIGO]
            cDesc     := SubStr(AllTrim(aConteudo[POSICAODESC]), 1, 30)
            cTipo     := aConteudo[POSICAOTIPO]
            cUm       := aConteudo[POSICAOUM]
            cPreco    := Val(aConteudo[POSICAOPRECO])
            cAtivo    := aConteudo[POSICAOATIVO]

            SB1->(DbSetOrder(1))  

            //? Se o código da linha atual não estiver cadastrado, ele vai ser incluido
            if !SB1->(DbSeek(FwFilial('SB1') + cCod))
                //? Só será cadastrado produtos Ativos
                if cAtivo == 'A'
                    oModel:SetValue('SB1MASTER', 'B1_FILIAL', FwFilial('SB1'))
                    oModel:SetValue('SB1MASTER', 'B1_COD'   , cCod)
                    oModel:SetValue('SB1MASTER', 'B1_DESC'  , cDesc)
                    oModel:SetValue('SB1MASTER', 'B1_TIPO'  , cTipo)
                    oModel:SetValue('SB1MASTER', 'B1_UM'    , cUm )
                    oModel:SetValue('SB1MASTER', 'B1_PRV1'  , cPreco)
                    oModel:SetValue('SB1MASTER', 'B1_LOCPAD', '01')
                    oModel:SetValue('SB1MASTER', 'B1_ATIVO' , 'S')
                    
                    if oModel:VldData()
                       oModel:CommitData() 
                    else
                        VarInfo('', oModel:GetErrorMessage())
                    endif
                endif
            endif   
        endif  
    end

    oArquivo:Close()

    oModel:DeActivate()
    oModel:Destroy()
    oModel := NIL

    SB1->(DbCloseArea())
    RestArea(aArea)
Return 
