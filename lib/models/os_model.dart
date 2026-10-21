enum StatusOS { aberta, emAndamento, concluida, cancelada }

class OrdemServico {
  final String id;
  final String cliente;
  final String descricao;
  final DateTime dataAbertura;
  StatusOS status;
  final String prioridade;

  OrdemServico({
    required this.id,
    required this.cliente,
    required this.descricao,
    required this.dataAbertura,
    this.status = StatusOS.aberta,
    required this.prioridade,
  });
}
