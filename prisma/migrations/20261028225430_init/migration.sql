-- CreateEnum
CREATE TYPE "StatusEndereco" AS ENUM ('DISPONIVEL', 'BLOQUEADO', 'MANUTENCAO');

-- CreateEnum
CREATE TYPE "TipoEndereco" AS ENUM ('RECEBIMENTO', 'ARMAZENAGEM', 'PICKING', 'PACKING', 'EXPEDICAO', 'DEVOLUCAO', 'QUARENTENA');

-- CreateEnum
CREATE TYPE "TipoRastreamento" AS ENUM ('NENHUM', 'LOTE', 'SERIE', 'LOTE_E_SERIE');

-- CreateEnum
CREATE TYPE "StatusEstoque" AS ENUM ('DISPONIVEL', 'BLOQUEADO', 'QUARENTENA', 'AVARIADO', 'VENCIDO');

-- CreateEnum
CREATE TYPE "TipoMovimento" AS ENUM ('RECEBIMENTO', 'ARMAZENAGEM', 'TRANSFERENCIA_ENTRADA', 'TRANSFERENCIA_SAIDA', 'AJUSTE_ENTRADA', 'AJUSTE_SAIDA', 'RESERVA', 'LIBERACAO_RESERVA', 'SEPARACAO', 'EXPEDICAO', 'DEVOLUCAO', 'BLOQUEIO', 'DESBLOQUEIO', 'ESTORNO');

-- CreateEnum
CREATE TYPE "StatusOperacao" AS ENUM ('RASCUNHO', 'PENDENTE', 'EM_ANDAMENTO', 'AGUARDANDO_APROVACAO', 'CONCLUIDO', 'CANCELADO', 'REJEITADO');

-- CreateEnum
CREATE TYPE "StatusPedido" AS ENUM ('RASCUNHO', 'RECEBIDO', 'LIBERADO', 'EM_SEPARACAO', 'SEPARADO', 'EM_PACKING', 'PRONTO_PARA_EXPEDICAO', 'PARCIALMENTE_EXPEDIDO', 'EXPEDIDO', 'CANCELADO');

-- CreateEnum
CREATE TYPE "StatusReserva" AS ENUM ('ATIVA', 'CONSUMIDA', 'LIBERADA', 'CANCELADA');

-- CreateEnum
CREATE TYPE "StatusInventario" AS ENUM ('RASCUNHO', 'ABERTO', 'EM_CONTAGEM', 'EM_APURACAO', 'AGUARDANDO_APROVACAO', 'CONCLUIDO', 'CANCELADO');

-- CreateEnum
CREATE TYPE "PapelUsuario" AS ENUM ('ADMINISTRADOR', 'SUPERVISOR', 'RECEBIMENTO', 'ESTOQUISTA', 'SEPARADOR', 'CONFERENTE', 'EXPEDICAO', 'AUDITOR', 'CONSULTA');

-- CreateEnum
CREATE TYPE "TipoParceiro" AS ENUM ('CLIENTE', 'FORNECEDOR', 'AMBOS');

-- CreateTable
CREATE TABLE "Empresa" (
    "id" UUID NOT NULL,
    "codigo" VARCHAR(30) NOT NULL,
    "razaoSocial" VARCHAR(180) NOT NULL,
    "nomeFantasia" VARCHAR(180),
    "cnpj" VARCHAR(14),
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "criadoEm" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "Empresa_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Deposito" (
    "id" UUID NOT NULL,
    "empresaId" UUID NOT NULL,
    "codigo" VARCHAR(30) NOT NULL,
    "nome" VARCHAR(120) NOT NULL,
    "fusoHorario" TEXT NOT NULL DEFAULT 'America/Sao_Paulo',
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "criadoEm" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Deposito_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Usuario" (
    "id" UUID NOT NULL,
    "empresaId" UUID NOT NULL,
    "nome" VARCHAR(120) NOT NULL,
    "email" VARCHAR(180) NOT NULL,
    "senhaHash" VARCHAR(255) NOT NULL,
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "ultimoLoginEm" TIMESTAMPTZ(3),
    "criadoEm" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Usuario_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UsuarioPapel" (
    "id" UUID NOT NULL,
    "usuarioId" UUID NOT NULL,
    "papel" "PapelUsuario" NOT NULL,

    CONSTRAINT "UsuarioPapel_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Categoria" (
    "id" UUID NOT NULL,
    "empresaId" UUID NOT NULL,
    "codigo" VARCHAR(40) NOT NULL,
    "nome" VARCHAR(120) NOT NULL,
    "ativo" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Categoria_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UnidadeMedida" (
    "id" UUID NOT NULL,
    "codigo" VARCHAR(20) NOT NULL,
    "nome" VARCHAR(80) NOT NULL,
    "casasDecimais" INTEGER NOT NULL DEFAULT 0,
    "ativo" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "UnidadeMedida_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Produto" (
    "id" UUID NOT NULL,
    "empresaId" UUID NOT NULL,
    "categoriaId" UUID,
    "unidadeId" UUID NOT NULL,
    "sku" VARCHAR(80) NOT NULL,
    "nome" VARCHAR(180) NOT NULL,
    "descricao" TEXT,
    "codigoBarras" VARCHAR(100),
    "rastreamento" "TipoRastreamento" NOT NULL DEFAULT 'NENHUM',
    "controlaValidade" BOOLEAN NOT NULL DEFAULT false,
    "estoqueMinimo" DECIMAL(18,4),
    "estoqueMaximo" DECIMAL(18,4),
    "pesoKg" DECIMAL(18,4),
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "criadoEm" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "Produto_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IdentificadorProduto" (
    "id" UUID NOT NULL,
    "produtoId" UUID NOT NULL,
    "tipo" VARCHAR(30) NOT NULL,
    "codigo" VARCHAR(100) NOT NULL,

    CONSTRAINT "IdentificadorProduto_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Parceiro" (
    "id" UUID NOT NULL,
    "empresaId" UUID NOT NULL,
    "codigo" VARCHAR(40) NOT NULL,
    "tipo" "TipoParceiro" NOT NULL,
    "razaoSocial" VARCHAR(180) NOT NULL,
    "nomeFantasia" TEXT,
    "cnpj" VARCHAR(14),
    "email" TEXT,
    "telefone" TEXT,
    "ativo" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Parceiro_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Endereco" (
    "id" UUID NOT NULL,
    "depositoId" UUID NOT NULL,
    "enderecoPaiId" UUID,
    "codigo" VARCHAR(60) NOT NULL,
    "tipo" "TipoEndereco" NOT NULL,
    "status" "StatusEndereco" NOT NULL DEFAULT 'DISPONIVEL',
    "corredor" TEXT,
    "modulo" TEXT,
    "nivel" TEXT,
    "posicao" TEXT,
    "capacidadePesoKg" DECIMAL(18,4),
    "capacidadeVolumeM3" DECIMAL(18,6),
    "prioridadePicking" INTEGER NOT NULL DEFAULT 100,
    "permiteSkuMisto" BOOLEAN NOT NULL DEFAULT false,
    "permiteLoteMisto" BOOLEAN NOT NULL DEFAULT false,
    "ativo" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Endereco_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NotaFiscalEntrada" (
    "id" UUID NOT NULL,
    "empresaId" UUID NOT NULL,
    "chaveAcesso" VARCHAR(44),
    "numero" VARCHAR(30) NOT NULL,
    "serie" VARCHAR(10),
    "cnpjEmitente" VARCHAR(14),
    "dataEmissao" TIMESTAMPTZ(3),
    "xml" TEXT,
    "xmlStorageKey" TEXT,
    "status" "StatusOperacao" NOT NULL DEFAULT 'RASCUNHO',
    "valorTotal" DECIMAL(18,2),
    "importadaEm" TIMESTAMPTZ(3),
    "criadoEm" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "NotaFiscalEntrada_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ItemNotaFiscal" (
    "id" UUID NOT NULL,
    "notaFiscalId" UUID NOT NULL,
    "numeroItem" INTEGER NOT NULL,
    "produtoId" UUID,
    "codigoFornecedor" TEXT,
    "descricao" TEXT NOT NULL,
    "unidade" TEXT,
    "quantidade" DECIMAL(18,4) NOT NULL,
    "valorUnitario" DECIMAL(18,6),
    "valorTotal" DECIMAL(18,2),

    CONSTRAINT "ItemNotaFiscal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Recebimento" (
    "id" UUID NOT NULL,
    "depositoId" UUID NOT NULL,
    "parceiroId" UUID NOT NULL,
    "notaFiscalId" UUID,
    "codigo" VARCHAR(40) NOT NULL,
    "status" "StatusOperacao" NOT NULL DEFAULT 'PENDENTE',
    "agendadoEm" TIMESTAMPTZ(3),
    "iniciadoEm" TIMESTAMPTZ(3),
    "concluidoEm" TIMESTAMPTZ(3),
    "observacao" TEXT,
    "criadoEm" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Recebimento_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ItemRecebimento" (
    "id" UUID NOT NULL,
    "recebimentoId" UUID NOT NULL,
    "produtoId" UUID NOT NULL,
    "itemNotaFiscalId" UUID,
    "quantidadeEsperada" DECIMAL(18,4) NOT NULL DEFAULT 0,
    "quantidadeContada" DECIMAL(18,4) NOT NULL DEFAULT 0,
    "quantidadeAceita" DECIMAL(18,4) NOT NULL DEFAULT 0,
    "quantidadeRejeitada" DECIMAL(18,4) NOT NULL DEFAULT 0,
    "observacao" TEXT,

    CONSTRAINT "ItemRecebimento_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RecebimentoLote" (
    "id" UUID NOT NULL,
    "itemRecebimentoId" UUID NOT NULL,
    "codigoLote" TEXT,
    "numeroSerie" TEXT,
    "validade" TIMESTAMPTZ(3),
    "quantidade" DECIMAL(18,4) NOT NULL,

    CONSTRAINT "RecebimentoLote_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarefaArmazenagem" (
    "id" UUID NOT NULL,
    "recebimentoId" UUID NOT NULL,
    "produtoId" UUID NOT NULL,
    "enderecoId" UUID,
    "loteId" UUID,
    "quantidade" DECIMAL(18,4) NOT NULL,
    "quantidadeConfirmada" DECIMAL(18,4) NOT NULL DEFAULT 0,
    "status" "StatusOperacao" NOT NULL DEFAULT 'PENDENTE',
    "operadorId" UUID,
    "iniciadoEm" TIMESTAMPTZ(3),
    "concluidoEm" TIMESTAMPTZ(3),

    CONSTRAINT "TarefaArmazenagem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Lote" (
    "id" UUID NOT NULL,
    "produtoId" UUID NOT NULL,
    "codigo" VARCHAR(100) NOT NULL,
    "fabricadoEm" TIMESTAMPTZ(3),
    "validade" TIMESTAMPTZ(3),
    "loteFornecedor" TEXT,
    "status" "StatusEstoque" NOT NULL DEFAULT 'DISPONIVEL',

    CONSTRAINT "Lote_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NumeroSerie" (
    "id" UUID NOT NULL,
    "produtoId" UUID NOT NULL,
    "loteId" UUID,
    "numero" VARCHAR(120) NOT NULL,
    "status" "StatusEstoque" NOT NULL DEFAULT 'DISPONIVEL',
    "enderecoAtualId" UUID,

    CONSTRAINT "NumeroSerie_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SaldoEstoque" (
    "id" UUID NOT NULL,
    "depositoId" UUID NOT NULL,
    "enderecoId" UUID NOT NULL,
    "produtoId" UUID NOT NULL,
    "loteId" UUID,
    "status" "StatusEstoque" NOT NULL DEFAULT 'DISPONIVEL',
    "quantidade" DECIMAL(18,4) NOT NULL DEFAULT 0,
    "reservada" DECIMAL(18,4) NOT NULL DEFAULT 0,
    "atualizadoEm" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "SaldoEstoque_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MovimentoEstoque" (
    "id" UUID NOT NULL,
    "depositoId" UUID NOT NULL,
    "produtoId" UUID NOT NULL,
    "loteId" UUID,
    "enderecoOrigemId" UUID,
    "enderecoDestinoId" UUID,
    "tipo" "TipoMovimento" NOT NULL,
    "statusEstoque" "StatusEstoque" NOT NULL DEFAULT 'DISPONIVEL',
    "quantidade" DECIMAL(18,4) NOT NULL,
    "referenciaTipo" VARCHAR(50),
    "referenciaId" UUID,
    "referenciaCodigo" VARCHAR(80),
    "chaveIdempotencia" VARCHAR(100),
    "motivo" TEXT,
    "metadados" JSONB,
    "usuarioId" UUID,
    "ocorridoEm" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "MovimentoEstoque_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AjusteEstoque" (
    "id" UUID NOT NULL,
    "depositoId" UUID NOT NULL,
    "codigo" VARCHAR(40) NOT NULL,
    "status" "StatusOperacao" NOT NULL DEFAULT 'RASCUNHO',
    "motivo" TEXT NOT NULL,
    "criadoPorId" UUID NOT NULL,
    "aprovadoPorId" UUID,
    "aprovadoEm" TIMESTAMPTZ(3),
    "executadoEm" TIMESTAMPTZ(3),
    "criadoEm" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AjusteEstoque_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ItemAjusteEstoque" (
    "id" UUID NOT NULL,
    "ajusteId" UUID NOT NULL,
    "produtoId" UUID NOT NULL,
    "enderecoId" UUID NOT NULL,
    "loteId" UUID,
    "quantidadeSistema" DECIMAL(18,4) NOT NULL,
    "quantidadeContada" DECIMAL(18,4) NOT NULL,
    "diferenca" DECIMAL(18,4) NOT NULL,

    CONSTRAINT "ItemAjusteEstoque_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RegraDePara" (
    "id" UUID NOT NULL,
    "empresaId" UUID NOT NULL,
    "tipo" VARCHAR(30) NOT NULL,
    "codigoOrigem" VARCHAR(100) NOT NULL,
    "codigoDestino" VARCHAR(100) NOT NULL,
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "criadoEm" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RegraDePara_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Pedido" (
    "id" UUID NOT NULL,
    "depositoId" UUID NOT NULL,
    "clienteId" UUID NOT NULL,
    "codigo" VARCHAR(50) NOT NULL,
    "codigoExterno" VARCHAR(80),
    "status" "StatusPedido" NOT NULL DEFAULT 'RASCUNHO',
    "prioridade" INTEGER NOT NULL DEFAULT 100,
    "expedirAte" TIMESTAMPTZ(3),
    "referenciaCliente" TEXT,
    "enderecoEntrega" JSONB,
    "observacao" TEXT,
    "criadoEm" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMPTZ(3) NOT NULL,

    CONSTRAINT "Pedido_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ItemPedido" (
    "id" UUID NOT NULL,
    "pedidoId" UUID NOT NULL,
    "numeroItem" INTEGER NOT NULL,
    "produtoId" UUID NOT NULL,
    "quantidadeSolicitada" DECIMAL(18,4) NOT NULL,
    "quantidadeReservada" DECIMAL(18,4) NOT NULL DEFAULT 0,
    "quantidadeSeparada" DECIMAL(18,4) NOT NULL DEFAULT 0,
    "quantidadeExpedida" DECIMAL(18,4) NOT NULL DEFAULT 0,
    "valorUnitario" DECIMAL(18,6),

    CONSTRAINT "ItemPedido_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ReservaEstoque" (
    "id" UUID NOT NULL,
    "pedidoId" UUID NOT NULL,
    "itemPedidoId" UUID NOT NULL,
    "saldoId" UUID NOT NULL,
    "quantidade" DECIMAL(18,4) NOT NULL,
    "status" "StatusReserva" NOT NULL DEFAULT 'ATIVA',
    "criadoEm" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "liberadoEm" TIMESTAMPTZ(3),

    CONSTRAINT "ReservaEstoque_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OndaSeparacao" (
    "id" UUID NOT NULL,
    "depositoId" UUID NOT NULL,
    "codigo" VARCHAR(40) NOT NULL,
    "estrategia" VARCHAR(20) NOT NULL DEFAULT 'FEFO',
    "status" "StatusOperacao" NOT NULL DEFAULT 'RASCUNHO',
    "liberadaEm" TIMESTAMPTZ(3),
    "concluidaEm" TIMESTAMPTZ(3),
    "criadoEm" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "OndaSeparacao_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OndaPedido" (
    "id" UUID NOT NULL,
    "ondaId" UUID NOT NULL,
    "pedidoId" UUID NOT NULL,

    CONSTRAINT "OndaPedido_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TarefaSeparacao" (
    "id" UUID NOT NULL,
    "ondaId" UUID,
    "itemPedidoId" UUID NOT NULL,
    "enderecoId" UUID NOT NULL,
    "loteId" UUID,
    "quantidade" DECIMAL(18,4) NOT NULL,
    "quantidadeSeparada" DECIMAL(18,4) NOT NULL DEFAULT 0,
    "status" "StatusOperacao" NOT NULL DEFAULT 'PENDENTE',
    "operadorId" UUID,
    "iniciadoEm" TIMESTAMPTZ(3),
    "concluidoEm" TIMESTAMPTZ(3),

    CONSTRAINT "TarefaSeparacao_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Packing" (
    "id" UUID NOT NULL,
    "pedidoId" UUID NOT NULL,
    "codigo" VARCHAR(40) NOT NULL,
    "status" "StatusOperacao" NOT NULL DEFAULT 'EM_ANDAMENTO',
    "conferenteId" UUID,
    "iniciadoEm" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "concluidoEm" TIMESTAMPTZ(3),

    CONSTRAINT "Packing_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Volume" (
    "id" UUID NOT NULL,
    "packingId" UUID NOT NULL,
    "codigo" VARCHAR(60) NOT NULL,
    "rastreio" VARCHAR(100),
    "pesoKg" DECIMAL(18,4),
    "comprimentoCm" DECIMAL(18,2),
    "larguraCm" DECIMAL(18,2),
    "alturaCm" DECIMAL(18,2),

    CONSTRAINT "Volume_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ItemVolume" (
    "id" UUID NOT NULL,
    "volumeId" UUID NOT NULL,
    "itemPedidoId" UUID NOT NULL,
    "quantidade" DECIMAL(18,4) NOT NULL,

    CONSTRAINT "ItemVolume_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Expedicao" (
    "id" UUID NOT NULL,
    "depositoId" UUID NOT NULL,
    "pedidoId" UUID NOT NULL,
    "codigo" VARCHAR(50) NOT NULL,
    "status" "StatusOperacao" NOT NULL DEFAULT 'RASCUNHO',
    "transportadora" TEXT,
    "codigoRastreio" TEXT,
    "numeroNotaFiscal" TEXT,
    "expedidoEm" TIMESTAMPTZ(3),
    "expedidoPorId" UUID,
    "comprovanteStorageKey" TEXT,
    "criadoEm" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Expedicao_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ItemExpedicao" (
    "id" UUID NOT NULL,
    "expedicaoId" UUID NOT NULL,
    "itemPedidoId" UUID NOT NULL,
    "produtoId" UUID NOT NULL,
    "loteId" UUID,
    "quantidade" DECIMAL(18,4) NOT NULL,

    CONSTRAINT "ItemExpedicao_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Romaneio" (
    "id" UUID NOT NULL,
    "depositoId" UUID NOT NULL,
    "codigo" VARCHAR(50) NOT NULL,
    "transportadora" TEXT,
    "motorista" TEXT,
    "documentoMotorista" TEXT,
    "placaVeiculo" VARCHAR(10),
    "status" "StatusOperacao" NOT NULL DEFAULT 'RASCUNHO',
    "previstoEm" TIMESTAMPTZ(3),
    "fechadoEm" TIMESTAMPTZ(3),
    "expedidoEm" TIMESTAMPTZ(3),

    CONSTRAINT "Romaneio_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ItemRomaneio" (
    "id" UUID NOT NULL,
    "romaneioId" UUID NOT NULL,
    "expedicaoId" UUID NOT NULL,

    CONSTRAINT "ItemRomaneio_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Inventario" (
    "id" UUID NOT NULL,
    "depositoId" UUID NOT NULL,
    "codigo" VARCHAR(40) NOT NULL,
    "status" "StatusInventario" NOT NULL DEFAULT 'RASCUNHO',
    "contagemCega" BOOLEAN NOT NULL DEFAULT true,
    "escopo" JSONB,
    "abertoEm" TIMESTAMPTZ(3),
    "fechadoEm" TIMESTAMPTZ(3),
    "criadoPorId" UUID NOT NULL,
    "aprovadoPorId" UUID,
    "criadoEm" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Inventario_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ItemInventario" (
    "id" UUID NOT NULL,
    "inventarioId" UUID NOT NULL,
    "enderecoId" UUID NOT NULL,
    "produtoId" UUID NOT NULL,
    "loteId" UUID,
    "quantidadeSistema" DECIMAL(18,4) NOT NULL,
    "quantidadeContada" DECIMAL(18,4),
    "diferenca" DECIMAL(18,4),
    "numeroContagem" INTEGER NOT NULL DEFAULT 1,
    "contadoPorId" UUID,
    "contadoEm" TIMESTAMPTZ(3),
    "observacao" TEXT,

    CONSTRAINT "ItemInventario_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ImportacaoMassa" (
    "id" UUID NOT NULL,
    "empresaId" UUID NOT NULL,
    "tipo" VARCHAR(50) NOT NULL,
    "status" "StatusOperacao" NOT NULL DEFAULT 'PENDENTE',
    "nomeArquivo" TEXT,
    "storageKey" TEXT,
    "totalLinhas" INTEGER NOT NULL DEFAULT 0,
    "linhasSucesso" INTEGER NOT NULL DEFAULT 0,
    "linhasErro" INTEGER NOT NULL DEFAULT 0,
    "detalhesErros" JSONB,
    "solicitadoPorId" UUID,
    "criadoEm" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "concluidoEm" TIMESTAMPTZ(3),

    CONSTRAINT "ImportacaoMassa_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Auditoria" (
    "id" UUID NOT NULL,
    "empresaId" UUID,
    "usuarioId" UUID,
    "entidade" VARCHAR(80) NOT NULL,
    "entidadeId" UUID,
    "acao" VARCHAR(100) NOT NULL,
    "dadosAntes" JSONB,
    "dadosDepois" JSONB,
    "enderecoIp" VARCHAR(45),
    "userAgent" TEXT,
    "criadoEm" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Auditoria_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Empresa_codigo_key" ON "Empresa"("codigo");

-- CreateIndex
CREATE INDEX "Deposito_empresaId_ativo_idx" ON "Deposito"("empresaId", "ativo");

-- CreateIndex
CREATE UNIQUE INDEX "Deposito_empresaId_codigo_key" ON "Deposito"("empresaId", "codigo");

-- CreateIndex
CREATE INDEX "Usuario_empresaId_ativo_idx" ON "Usuario"("empresaId", "ativo");

-- CreateIndex
CREATE UNIQUE INDEX "Usuario_empresaId_email_key" ON "Usuario"("empresaId", "email");

-- CreateIndex
CREATE UNIQUE INDEX "UsuarioPapel_usuarioId_papel_key" ON "UsuarioPapel"("usuarioId", "papel");

-- CreateIndex
CREATE UNIQUE INDEX "Categoria_empresaId_codigo_key" ON "Categoria"("empresaId", "codigo");

-- CreateIndex
CREATE UNIQUE INDEX "UnidadeMedida_codigo_key" ON "UnidadeMedida"("codigo");

-- CreateIndex
CREATE INDEX "Produto_empresaId_nome_idx" ON "Produto"("empresaId", "nome");

-- CreateIndex
CREATE INDEX "Produto_codigoBarras_idx" ON "Produto"("codigoBarras");

-- CreateIndex
CREATE INDEX "Produto_empresaId_ativo_idx" ON "Produto"("empresaId", "ativo");

-- CreateIndex
CREATE UNIQUE INDEX "Produto_empresaId_sku_key" ON "Produto"("empresaId", "sku");

-- CreateIndex
CREATE INDEX "IdentificadorProduto_produtoId_idx" ON "IdentificadorProduto"("produtoId");

-- CreateIndex
CREATE UNIQUE INDEX "IdentificadorProduto_tipo_codigo_key" ON "IdentificadorProduto"("tipo", "codigo");

-- CreateIndex
CREATE INDEX "Parceiro_empresaId_cnpj_idx" ON "Parceiro"("empresaId", "cnpj");

-- CreateIndex
CREATE INDEX "Parceiro_empresaId_razaoSocial_idx" ON "Parceiro"("empresaId", "razaoSocial");

-- CreateIndex
CREATE UNIQUE INDEX "Parceiro_empresaId_codigo_key" ON "Parceiro"("empresaId", "codigo");

-- CreateIndex
CREATE INDEX "Endereco_depositoId_tipo_status_ativo_idx" ON "Endereco"("depositoId", "tipo", "status", "ativo");

-- CreateIndex
CREATE UNIQUE INDEX "Endereco_depositoId_codigo_key" ON "Endereco"("depositoId", "codigo");

-- CreateIndex
CREATE UNIQUE INDEX "NotaFiscalEntrada_chaveAcesso_key" ON "NotaFiscalEntrada"("chaveAcesso");

-- CreateIndex
CREATE INDEX "NotaFiscalEntrada_empresaId_status_dataEmissao_idx" ON "NotaFiscalEntrada"("empresaId", "status", "dataEmissao");

-- CreateIndex
CREATE UNIQUE INDEX "NotaFiscalEntrada_empresaId_numero_serie_cnpjEmitente_key" ON "NotaFiscalEntrada"("empresaId", "numero", "serie", "cnpjEmitente");

-- CreateIndex
CREATE INDEX "ItemNotaFiscal_produtoId_idx" ON "ItemNotaFiscal"("produtoId");

-- CreateIndex
CREATE UNIQUE INDEX "ItemNotaFiscal_notaFiscalId_numeroItem_key" ON "ItemNotaFiscal"("notaFiscalId", "numeroItem");

-- CreateIndex
CREATE INDEX "Recebimento_depositoId_status_criadoEm_idx" ON "Recebimento"("depositoId", "status", "criadoEm");

-- CreateIndex
CREATE UNIQUE INDEX "Recebimento_depositoId_codigo_key" ON "Recebimento"("depositoId", "codigo");

-- CreateIndex
CREATE INDEX "ItemRecebimento_recebimentoId_produtoId_idx" ON "ItemRecebimento"("recebimentoId", "produtoId");

-- CreateIndex
CREATE INDEX "RecebimentoLote_itemRecebimentoId_idx" ON "RecebimentoLote"("itemRecebimentoId");

-- CreateIndex
CREATE INDEX "TarefaArmazenagem_recebimentoId_status_idx" ON "TarefaArmazenagem"("recebimentoId", "status");

-- CreateIndex
CREATE INDEX "TarefaArmazenagem_status_operadorId_idx" ON "TarefaArmazenagem"("status", "operadorId");

-- CreateIndex
CREATE INDEX "Lote_produtoId_validade_status_idx" ON "Lote"("produtoId", "validade", "status");

-- CreateIndex
CREATE UNIQUE INDEX "Lote_produtoId_codigo_key" ON "Lote"("produtoId", "codigo");

-- CreateIndex
CREATE INDEX "NumeroSerie_numero_status_idx" ON "NumeroSerie"("numero", "status");

-- CreateIndex
CREATE UNIQUE INDEX "NumeroSerie_produtoId_numero_key" ON "NumeroSerie"("produtoId", "numero");

-- CreateIndex
CREATE INDEX "SaldoEstoque_depositoId_produtoId_status_idx" ON "SaldoEstoque"("depositoId", "produtoId", "status");

-- CreateIndex
CREATE INDEX "SaldoEstoque_enderecoId_produtoId_idx" ON "SaldoEstoque"("enderecoId", "produtoId");

-- CreateIndex
CREATE INDEX "SaldoEstoque_loteId_status_idx" ON "SaldoEstoque"("loteId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "SaldoEstoque_depositoId_enderecoId_produtoId_loteId_status_key" ON "SaldoEstoque"("depositoId", "enderecoId", "produtoId", "loteId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "MovimentoEstoque_chaveIdempotencia_key" ON "MovimentoEstoque"("chaveIdempotencia");

-- CreateIndex
CREATE INDEX "MovimentoEstoque_depositoId_ocorridoEm_idx" ON "MovimentoEstoque"("depositoId", "ocorridoEm");

-- CreateIndex
CREATE INDEX "MovimentoEstoque_produtoId_ocorridoEm_idx" ON "MovimentoEstoque"("produtoId", "ocorridoEm");

-- CreateIndex
CREATE INDEX "MovimentoEstoque_loteId_ocorridoEm_idx" ON "MovimentoEstoque"("loteId", "ocorridoEm");

-- CreateIndex
CREATE INDEX "MovimentoEstoque_referenciaTipo_referenciaId_idx" ON "MovimentoEstoque"("referenciaTipo", "referenciaId");

-- CreateIndex
CREATE INDEX "MovimentoEstoque_enderecoOrigemId_ocorridoEm_idx" ON "MovimentoEstoque"("enderecoOrigemId", "ocorridoEm");

-- CreateIndex
CREATE INDEX "MovimentoEstoque_enderecoDestinoId_ocorridoEm_idx" ON "MovimentoEstoque"("enderecoDestinoId", "ocorridoEm");

-- CreateIndex
CREATE INDEX "AjusteEstoque_depositoId_status_criadoEm_idx" ON "AjusteEstoque"("depositoId", "status", "criadoEm");

-- CreateIndex
CREATE UNIQUE INDEX "AjusteEstoque_depositoId_codigo_key" ON "AjusteEstoque"("depositoId", "codigo");

-- CreateIndex
CREATE INDEX "ItemAjusteEstoque_ajusteId_produtoId_idx" ON "ItemAjusteEstoque"("ajusteId", "produtoId");

-- CreateIndex
CREATE INDEX "RegraDePara_empresaId_tipo_ativo_idx" ON "RegraDePara"("empresaId", "tipo", "ativo");

-- CreateIndex
CREATE UNIQUE INDEX "RegraDePara_empresaId_tipo_codigoOrigem_codigoDestino_key" ON "RegraDePara"("empresaId", "tipo", "codigoOrigem", "codigoDestino");

-- CreateIndex
CREATE INDEX "Pedido_depositoId_status_prioridade_expedirAte_idx" ON "Pedido"("depositoId", "status", "prioridade", "expedirAte");

-- CreateIndex
CREATE INDEX "Pedido_clienteId_criadoEm_idx" ON "Pedido"("clienteId", "criadoEm");

-- CreateIndex
CREATE UNIQUE INDEX "Pedido_depositoId_codigo_key" ON "Pedido"("depositoId", "codigo");

-- CreateIndex
CREATE INDEX "ItemPedido_produtoId_idx" ON "ItemPedido"("produtoId");

-- CreateIndex
CREATE UNIQUE INDEX "ItemPedido_pedidoId_numeroItem_key" ON "ItemPedido"("pedidoId", "numeroItem");

-- CreateIndex
CREATE INDEX "ReservaEstoque_pedidoId_status_idx" ON "ReservaEstoque"("pedidoId", "status");

-- CreateIndex
CREATE INDEX "ReservaEstoque_saldoId_status_idx" ON "ReservaEstoque"("saldoId", "status");

-- CreateIndex
CREATE INDEX "OndaSeparacao_depositoId_status_criadoEm_idx" ON "OndaSeparacao"("depositoId", "status", "criadoEm");

-- CreateIndex
CREATE UNIQUE INDEX "OndaSeparacao_depositoId_codigo_key" ON "OndaSeparacao"("depositoId", "codigo");

-- CreateIndex
CREATE UNIQUE INDEX "OndaPedido_ondaId_pedidoId_key" ON "OndaPedido"("ondaId", "pedidoId");

-- CreateIndex
CREATE INDEX "TarefaSeparacao_status_operadorId_idx" ON "TarefaSeparacao"("status", "operadorId");

-- CreateIndex
CREATE INDEX "TarefaSeparacao_ondaId_status_idx" ON "TarefaSeparacao"("ondaId", "status");

-- CreateIndex
CREATE INDEX "TarefaSeparacao_itemPedidoId_idx" ON "TarefaSeparacao"("itemPedidoId");

-- CreateIndex
CREATE UNIQUE INDEX "Packing_codigo_key" ON "Packing"("codigo");

-- CreateIndex
CREATE UNIQUE INDEX "Volume_codigo_key" ON "Volume"("codigo");

-- CreateIndex
CREATE INDEX "Volume_packingId_idx" ON "Volume"("packingId");

-- CreateIndex
CREATE INDEX "ItemVolume_itemPedidoId_idx" ON "ItemVolume"("itemPedidoId");

-- CreateIndex
CREATE INDEX "Expedicao_depositoId_status_expedidoEm_idx" ON "Expedicao"("depositoId", "status", "expedidoEm");

-- CreateIndex
CREATE INDEX "Expedicao_pedidoId_idx" ON "Expedicao"("pedidoId");

-- CreateIndex
CREATE UNIQUE INDEX "Expedicao_depositoId_codigo_key" ON "Expedicao"("depositoId", "codigo");

-- CreateIndex
CREATE INDEX "ItemExpedicao_expedicaoId_produtoId_idx" ON "ItemExpedicao"("expedicaoId", "produtoId");

-- CreateIndex
CREATE INDEX "ItemExpedicao_itemPedidoId_idx" ON "ItemExpedicao"("itemPedidoId");

-- CreateIndex
CREATE INDEX "Romaneio_depositoId_status_previstoEm_idx" ON "Romaneio"("depositoId", "status", "previstoEm");

-- CreateIndex
CREATE UNIQUE INDEX "Romaneio_depositoId_codigo_key" ON "Romaneio"("depositoId", "codigo");

-- CreateIndex
CREATE UNIQUE INDEX "ItemRomaneio_romaneioId_expedicaoId_key" ON "ItemRomaneio"("romaneioId", "expedicaoId");

-- CreateIndex
CREATE INDEX "Inventario_depositoId_status_criadoEm_idx" ON "Inventario"("depositoId", "status", "criadoEm");

-- CreateIndex
CREATE UNIQUE INDEX "Inventario_depositoId_codigo_key" ON "Inventario"("depositoId", "codigo");

-- CreateIndex
CREATE INDEX "ItemInventario_inventarioId_enderecoId_produtoId_idx" ON "ItemInventario"("inventarioId", "enderecoId", "produtoId");

-- CreateIndex
CREATE INDEX "ImportacaoMassa_empresaId_status_criadoEm_idx" ON "ImportacaoMassa"("empresaId", "status", "criadoEm");

-- CreateIndex
CREATE INDEX "Auditoria_empresaId_criadoEm_idx" ON "Auditoria"("empresaId", "criadoEm");

-- CreateIndex
CREATE INDEX "Auditoria_entidade_entidadeId_criadoEm_idx" ON "Auditoria"("entidade", "entidadeId", "criadoEm");

-- CreateIndex
CREATE INDEX "Auditoria_usuarioId_criadoEm_idx" ON "Auditoria"("usuarioId", "criadoEm");

-- AddForeignKey
ALTER TABLE "Deposito" ADD CONSTRAINT "Deposito_empresaId_fkey" FOREIGN KEY ("empresaId") REFERENCES "Empresa"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Usuario" ADD CONSTRAINT "Usuario_empresaId_fkey" FOREIGN KEY ("empresaId") REFERENCES "Empresa"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UsuarioPapel" ADD CONSTRAINT "UsuarioPapel_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuario"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Categoria" ADD CONSTRAINT "Categoria_empresaId_fkey" FOREIGN KEY ("empresaId") REFERENCES "Empresa"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Produto" ADD CONSTRAINT "Produto_empresaId_fkey" FOREIGN KEY ("empresaId") REFERENCES "Empresa"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Produto" ADD CONSTRAINT "Produto_categoriaId_fkey" FOREIGN KEY ("categoriaId") REFERENCES "Categoria"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Produto" ADD CONSTRAINT "Produto_unidadeId_fkey" FOREIGN KEY ("unidadeId") REFERENCES "UnidadeMedida"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IdentificadorProduto" ADD CONSTRAINT "IdentificadorProduto_produtoId_fkey" FOREIGN KEY ("produtoId") REFERENCES "Produto"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Parceiro" ADD CONSTRAINT "Parceiro_empresaId_fkey" FOREIGN KEY ("empresaId") REFERENCES "Empresa"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Endereco" ADD CONSTRAINT "Endereco_depositoId_fkey" FOREIGN KEY ("depositoId") REFERENCES "Deposito"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Endereco" ADD CONSTRAINT "Endereco_enderecoPaiId_fkey" FOREIGN KEY ("enderecoPaiId") REFERENCES "Endereco"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ItemNotaFiscal" ADD CONSTRAINT "ItemNotaFiscal_notaFiscalId_fkey" FOREIGN KEY ("notaFiscalId") REFERENCES "NotaFiscalEntrada"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Recebimento" ADD CONSTRAINT "Recebimento_depositoId_fkey" FOREIGN KEY ("depositoId") REFERENCES "Deposito"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Recebimento" ADD CONSTRAINT "Recebimento_parceiroId_fkey" FOREIGN KEY ("parceiroId") REFERENCES "Parceiro"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Recebimento" ADD CONSTRAINT "Recebimento_notaFiscalId_fkey" FOREIGN KEY ("notaFiscalId") REFERENCES "NotaFiscalEntrada"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ItemRecebimento" ADD CONSTRAINT "ItemRecebimento_recebimentoId_fkey" FOREIGN KEY ("recebimentoId") REFERENCES "Recebimento"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ItemRecebimento" ADD CONSTRAINT "ItemRecebimento_produtoId_fkey" FOREIGN KEY ("produtoId") REFERENCES "Produto"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RecebimentoLote" ADD CONSTRAINT "RecebimentoLote_itemRecebimentoId_fkey" FOREIGN KEY ("itemRecebimentoId") REFERENCES "ItemRecebimento"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Lote" ADD CONSTRAINT "Lote_produtoId_fkey" FOREIGN KEY ("produtoId") REFERENCES "Produto"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NumeroSerie" ADD CONSTRAINT "NumeroSerie_produtoId_fkey" FOREIGN KEY ("produtoId") REFERENCES "Produto"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NumeroSerie" ADD CONSTRAINT "NumeroSerie_loteId_fkey" FOREIGN KEY ("loteId") REFERENCES "Lote"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SaldoEstoque" ADD CONSTRAINT "SaldoEstoque_depositoId_fkey" FOREIGN KEY ("depositoId") REFERENCES "Deposito"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SaldoEstoque" ADD CONSTRAINT "SaldoEstoque_enderecoId_fkey" FOREIGN KEY ("enderecoId") REFERENCES "Endereco"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SaldoEstoque" ADD CONSTRAINT "SaldoEstoque_produtoId_fkey" FOREIGN KEY ("produtoId") REFERENCES "Produto"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SaldoEstoque" ADD CONSTRAINT "SaldoEstoque_loteId_fkey" FOREIGN KEY ("loteId") REFERENCES "Lote"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovimentoEstoque" ADD CONSTRAINT "MovimentoEstoque_depositoId_fkey" FOREIGN KEY ("depositoId") REFERENCES "Deposito"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovimentoEstoque" ADD CONSTRAINT "MovimentoEstoque_produtoId_fkey" FOREIGN KEY ("produtoId") REFERENCES "Produto"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovimentoEstoque" ADD CONSTRAINT "MovimentoEstoque_loteId_fkey" FOREIGN KEY ("loteId") REFERENCES "Lote"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovimentoEstoque" ADD CONSTRAINT "MovimentoEstoque_enderecoOrigemId_fkey" FOREIGN KEY ("enderecoOrigemId") REFERENCES "Endereco"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovimentoEstoque" ADD CONSTRAINT "MovimentoEstoque_enderecoDestinoId_fkey" FOREIGN KEY ("enderecoDestinoId") REFERENCES "Endereco"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MovimentoEstoque" ADD CONSTRAINT "MovimentoEstoque_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuario"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ItemAjusteEstoque" ADD CONSTRAINT "ItemAjusteEstoque_ajusteId_fkey" FOREIGN KEY ("ajusteId") REFERENCES "AjusteEstoque"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Pedido" ADD CONSTRAINT "Pedido_depositoId_fkey" FOREIGN KEY ("depositoId") REFERENCES "Deposito"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Pedido" ADD CONSTRAINT "Pedido_clienteId_fkey" FOREIGN KEY ("clienteId") REFERENCES "Parceiro"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ItemPedido" ADD CONSTRAINT "ItemPedido_pedidoId_fkey" FOREIGN KEY ("pedidoId") REFERENCES "Pedido"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ItemPedido" ADD CONSTRAINT "ItemPedido_produtoId_fkey" FOREIGN KEY ("produtoId") REFERENCES "Produto"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReservaEstoque" ADD CONSTRAINT "ReservaEstoque_pedidoId_fkey" FOREIGN KEY ("pedidoId") REFERENCES "Pedido"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ReservaEstoque" ADD CONSTRAINT "ReservaEstoque_itemPedidoId_fkey" FOREIGN KEY ("itemPedidoId") REFERENCES "ItemPedido"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OndaSeparacao" ADD CONSTRAINT "OndaSeparacao_depositoId_fkey" FOREIGN KEY ("depositoId") REFERENCES "Deposito"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OndaPedido" ADD CONSTRAINT "OndaPedido_ondaId_fkey" FOREIGN KEY ("ondaId") REFERENCES "OndaSeparacao"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OndaPedido" ADD CONSTRAINT "OndaPedido_pedidoId_fkey" FOREIGN KEY ("pedidoId") REFERENCES "Pedido"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarefaSeparacao" ADD CONSTRAINT "TarefaSeparacao_ondaId_fkey" FOREIGN KEY ("ondaId") REFERENCES "OndaSeparacao"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarefaSeparacao" ADD CONSTRAINT "TarefaSeparacao_itemPedidoId_fkey" FOREIGN KEY ("itemPedidoId") REFERENCES "ItemPedido"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TarefaSeparacao" ADD CONSTRAINT "TarefaSeparacao_enderecoId_fkey" FOREIGN KEY ("enderecoId") REFERENCES "Endereco"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Volume" ADD CONSTRAINT "Volume_packingId_fkey" FOREIGN KEY ("packingId") REFERENCES "Packing"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ItemVolume" ADD CONSTRAINT "ItemVolume_volumeId_fkey" FOREIGN KEY ("volumeId") REFERENCES "Volume"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Expedicao" ADD CONSTRAINT "Expedicao_pedidoId_fkey" FOREIGN KEY ("pedidoId") REFERENCES "Pedido"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ItemExpedicao" ADD CONSTRAINT "ItemExpedicao_expedicaoId_fkey" FOREIGN KEY ("expedicaoId") REFERENCES "Expedicao"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ItemRomaneio" ADD CONSTRAINT "ItemRomaneio_romaneioId_fkey" FOREIGN KEY ("romaneioId") REFERENCES "Romaneio"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ItemRomaneio" ADD CONSTRAINT "ItemRomaneio_expedicaoId_fkey" FOREIGN KEY ("expedicaoId") REFERENCES "Expedicao"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Inventario" ADD CONSTRAINT "Inventario_depositoId_fkey" FOREIGN KEY ("depositoId") REFERENCES "Deposito"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ItemInventario" ADD CONSTRAINT "ItemInventario_inventarioId_fkey" FOREIGN KEY ("inventarioId") REFERENCES "Inventario"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Auditoria" ADD CONSTRAINT "Auditoria_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuario"("id") ON DELETE SET NULL ON UPDATE CASCADE;
