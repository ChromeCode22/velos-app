import 'package:flutter/material.dart';
import 'models/os_model.dart';
import 'services/update_service.dart';

void main() {
  runApp(const VelOSApp());
}

class VelOSApp extends StatelessWidget {
  const VelOSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VelOS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<OrdemServico> ordens = [
    OrdemServico(
      id: 'OS-001',
      cliente: 'Tech Solutions Ltd',
      descricao: 'Troca de servidor de aplicação',
      dataAbertura: DateTime.now(),
      prioridade: 'Alta',
    ),
    OrdemServico(
      id: 'OS-002',
      cliente: 'Mercado Central',
      descricao: 'Manutenção preventiva no PDV',
      dataAbertura: DateTime.now().subtract(const Duration(days: 1)),
      status: StatusOS.emAndamento,
      prioridade: 'Média',
    ),
  ];

  @override
  void initState() {
    super.initState();
    UpdateService.checkForUpdates((apkUrl) {
      _showUpdateDialog(apkUrl);
    });
  }

  void _showUpdateDialog(String apkUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🚀 Nova Versão Disponível!'),
        content: const Text('Uma nova atualização do VelOS foi encontrada. Deseja atualizar agora?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Depois'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              UpdateService.downloadAndInstallApk(apkUrl);
            },
            child: const Text('Atualizar Agora'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(StatusOS status) {
    switch (status) {
      case StatusOS.aberta:
        return Colors.orange;
      case StatusOS.emAndamento:
        return Colors.blue;
      case StatusOS.concluida:
        return Colors.green;
      case StatusOS.cancelada:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VelOS - Gerenciador de OS', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: ordens.length,
        itemBuilder: (context, index) {
          final os = ordens[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getStatusColor(os.status),
                child: const Icon(Icons.build, color: Colors.white),
              ),
              title: Text('${os.id} - ${os.cliente}', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(os.descricao),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Chip(
                        label: Text(os.prioridade, style: const TextStyle(fontSize: 10, color: Colors.white)),
                        backgroundColor: os.prioridade == 'Alta' ? Colors.redAccent : Colors.grey,
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ],
              ),
              trailing: PopupMenuButton<StatusOS>(
                onSelected: (newStatus) {
                  setState(() {
                    os.status = newStatus;
                  });
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: StatusOS.aberta, child: Text('Aberta')),
                  const PopupMenuItem(value: StatusOS.emAndamento, child: Text('Em Andamento')),
                  const PopupMenuItem(value: StatusOS.concluida, child: Text('Concluída')),
                  const PopupMenuItem(value: StatusOS.cancelada, child: Text('Cancelada')),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
