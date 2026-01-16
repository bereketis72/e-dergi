import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'pdf_viewer_page.dart';


import 'web_helper_stub.dart' if (dart.library.html) 'web_helper.dart' as web_helper;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BATMAN ÜNİVERSİTESİ E-DERGİ PLATFORMU',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false, // Fix shader compilation error
        primarySwatch: Colors.teal,
        fontFamily: 'Roboto',
      ),
      home: const KitapListesi(),
    );
  }
}

// Kitap modeli
class Kitap {
  final String isim;
  final String pdfDosya;
  final String sayi;
  final String yil;

  final String? kapakResmi;

  const Kitap({
    required this.isim,
    required this.pdfDosya,
    required this.sayi,
    required this.yil,
    this.kapakResmi,
  });
}

class KitapListesi extends StatefulWidget {
  const KitapListesi({super.key});

  // Kitap listesi
  static const List<Kitap> kitaplar = [
     Kitap(
      isim: 'IIC 2025 Bildiriler Kitabı',
      pdfDosya: 'assets/pdfs/TAM METİN - FULL TEXT.pdf',
      sayi: 'IIc 2025',
      yil: '2025',
      kapakResmi: 'assets/covers/IIC2025_kapak.png',
    ),
    Kitap(
      isim: 'IIC 2024 Bildiriler Kitabı',
      pdfDosya: 'assets/pdfs/III.  Uluslararası Bilişim Kongresi Bildiriler Kitabı IIC 2024.pdf',
      sayi: 'IIC 2024',
      yil: '2024',
      kapakResmi: 'assets/covers/IIC2024_kapak.png',
    ),
    Kitap(
      isim: 'IIC 2023 Bildiriler Kitabı',
      pdfDosya: 'assets/pdfs/Uluslararası Bilişim Kongresi (IIC2023) Bildiriler Kitabı.pdf',
      sayi: 'IIC 2023',
      yil: '2023',
      kapakResmi: 'assets/covers/IIC2023_kapak.png',
    ),
    Kitap(
      isim: 'IIC 2022 Bildiriler Kitabı',
      pdfDosya: 'assets/pdfs/Uluslararası Bilişim Kongresi Bildiriler Kitabı.pdf',
      sayi: 'IIC 2022',
      yil: '2022',
      kapakResmi: 'assets/covers/IIC2022_kapak.png',
    ),
  ];

  @override
  State<KitapListesi> createState() => _KitapListesiState();
}

class _KitapListesiState extends State<KitapListesi> {
  String _aramaMetni = '';
  final TextEditingController _aramaController = TextEditingController();

  // Filtrelenmiş kitap listesi
  List<Kitap> get _filtrelenmisKitaplar {
    if (_aramaMetni.isEmpty) {
      return KitapListesi.kitaplar;
    }
    return KitapListesi.kitaplar.where((kitap) {
      final aramaKucuk = _aramaMetni.toLowerCase();
      return kitap.isim.toLowerCase().contains(aramaKucuk) ||
          kitap.sayi.toLowerCase().contains(aramaKucuk) ||
          kitap.yil.contains(aramaKucuk);
    }).toList();
  }


  void _kitapAc(Kitap kitap) {
    if (kIsWeb) {
      final String baseUrl = web_helper.getOrigin();
      final String flipbookUrl = '$baseUrl/flipbook.html?pdf=${Uri.encodeComponent(kitap.pdfDosya)}&title=${Uri.encodeComponent(kitap.isim)}';
      web_helper.openUrl(flipbookUrl);
    } else {
     Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewerPage(
            pdfPath: kitap.pdfDosya,
            title: kitap.isim,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _aramaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    // Responsive grid sütun sayısı
    int crossAxisCount = 4; // Desktop
    if (isMobile) {
      crossAxisCount = 1;
    } else if (isTablet) {
      crossAxisCount = 2;
    }

    // Responsive padding
    double padding = isMobile ? 16 : 40;

    return Scaffold(
      body: Stack(
        children: [
          // Arka plan fotoğrafı
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: Image.asset(
                'assets/logo.jpg',
                width: 1200,
                height: 1200,
                fit: BoxFit.contain,
              ),
            ),
          ),
      
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          // Ana içerik
          Column(
        children: [
          // Üst Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 40,
              vertical: isMobile ? 12 : 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isMobile
                ? Column(
                    children: [
                      // Logo ve Başlık 
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/logo.jpg',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BATMAN ÜNİVERSİTESİ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A237E),
                                  ),
                                ),
                                Text(
                                  'E-DERGİ PLATFORMU',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Arama Kutusu
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextField(
                          controller: _aramaController,
                          onChanged: (value) {
                            setState(() {
                              _aramaMetni = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Dergi ara...',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                            prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      // Logo
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/logo.jpg',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 15),
                      // Başlık
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BATMAN ÜNİVERSİTESİ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A237E),
                            ),
                          ),
                          Text(
                            'E-DERGİ PLATFORMU',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Arama Kutusu 
                      Container(
                        width: 250,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: TextField(
                          controller: _aramaController,
                          onChanged: (value) {
                            setState(() {
                              _aramaMetni = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Aramak İstediğiniz Dergi ...',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                            prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Menü ikonu
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.menu, size: 28),
                      ),
                    ],
                  ),
          ),

     
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: _filtrelenmisKitaplar.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Sonuç bulunamadı',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '"$_aramaMetni" ile eşleşen dergi yok',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.707,
                        crossAxisSpacing: isMobile ? 0 : 30,
                        mainAxisSpacing: isMobile ? 20 : 30,
                      ),
                      itemCount: _filtrelenmisKitaplar.length,
                      itemBuilder: (context, index) {
                        return KitapKarti(
                          kitap: _filtrelenmisKitaplar[index],
                          onTap: () => _kitapAc(_filtrelenmisKitaplar[index]),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
        ],
      ),
    );
  }
}

// Kitap Kartı Widget'ı
class KitapKarti extends StatefulWidget {
  final Kitap kitap;
  final VoidCallback onTap;

  const KitapKarti({super.key, required this.kitap, required this.onTap});

  @override
  State<KitapKarti> createState() => _KitapKartiState();
}

class _KitapKartiState extends State<KitapKarti> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: _isHovered
              ? (Matrix4.identity()..translate(0.0, -8.0))
              : Matrix4.identity(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Kapak Resmi Container
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: _isHovered
                            ? Colors.black.withOpacity(0.3)
                            : Colors.black.withOpacity(0.15),
                        blurRadius: _isHovered ? 20 : 10,
                        offset: Offset(0, _isHovered ? 10 : 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Kapak resmi veya placeholder gradient
                        widget.kitap.kapakResmi != null
                            ? Image.asset(
                                widget.kitap.kapakResmi!,
                                fit: BoxFit.fill, // Tam sığdır
                                width: double.infinity,
                                height: double.infinity,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: _getGradientColors(
                                        KitapListesi.kitaplar.indexOf(widget.kitap)),
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.menu_book,
                                        size: 60,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        widget.kitap.sayi,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        // Hover overlay
                        if (_isHovered)
                          Container(
                            color: Colors.black.withOpacity(0.2),
                            child: const Center(
                              child: Icon(
                                Icons.visibility,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Kitap Adı
              Text(
                widget.kitap.isim,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              // Alt bilgi
              Text(
                '${widget.kitap.sayi}\n${widget.kitap.yil}',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(int index) {
    final gradients = [
      [const Color(0xFF667eea), const Color(0xFF764ba2)],
      [const Color(0xFFf093fb), const Color(0xFFf5576c)],
      [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
      [const Color(0xFFfa709a), const Color(0xFFfee140)],
      [const Color(0xFF30cfd0), const Color(0xFF330867)],
    ];
    return gradients[index % gradients.length];
  }
}
