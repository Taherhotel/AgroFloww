import '../models/plant_knowledge.dart';

class KnowledgeService {
  static final List<PlantKnowledge> leafyVeggies = [
    PlantKnowledge(
      id: 'lettuce',
      name: {
        'en': 'Lettuce',
        'mr': 'लेट्यूस (Lettuce)',
        'hi': 'लेट्यूस (Lettuce)',
      },
      scientificName: 'Lactuca sativa',
      description: {
        'en':
            'Lettuce is the most popular hydroponic crop. It grows fast, takes up little space, and has a high market demand.',
        'mr':
            'लेट्यूस हे हायड्रोपोनिक्स मधील सर्वात लोकप्रिय पीक आहे. हे वेगाने वाढते, कमी जागा घेते आणि त्याला बाजारात मोठी मागणी आहे.',
        'hi':
            'लेट्यूस हाइड्रोपोनिक्स में सबसे लोकप्रिय फसल है। यह तेजी से बढ़ता है, कम जगह लेता है और बाजार में इसकी उच्च मांग है।',
      },
      nutritionalBenefits: {
        'en': [
          'Rich in Vitamin K and A',
          'High water content for hydration',
          'Contains antioxidants',
          'Low in calories',
        ],
        'mr': [
          'जीवनसत्त्व के आणि अ ने समृद्ध',
          'हायड्रेशनसाठी पाण्याचे प्रमाण जास्त',
          'अँटिऑक्सिडंट्स असतात',
          'कॅलरीज कमी असतात',
        ],
        'hi': [
          'विटामिन के और ए से भरपूर',
          'हाइड्रेशन के लिए पानी की मात्रा अधिक',
          'एंटीऑक्सीडेंट होते हैं',
          'कैलोरी कम होती है',
        ],
      },
      guide: HydroponicGuide(
        difficulty: {'en': 'Easy', 'mr': 'सोपे', 'hi': 'आसान'},
        germinationTime: {'en': '2-7 days', 'mr': '२-७ दिवस', 'hi': '२-७ दिन'},
        harvestTime: {
          'en': '30-45 days',
          'mr': '३०-४५ दिवस',
          'hi': '३०-४५ दिन',
        },
        phRange: '5.5 - 6.5',
        ecRange: '0.8 - 1.2 mS/cm',
        temperatureRange: '15°C - 22°C',
        steps: {
          'en': [
            'Germination: Start seeds in rockwool cubes or peat plugs. Keep moist and warm.',
            'Seedling Stage: Once true leaves appear (10-14 days), transplant to the hydroponic system (NFT or DWC).',
            'Vegetative Growth: Maintain pH around 6.0 and EC at 1.0. Ensure adequate light (12-14 hours).',
            'Harvest: Harvest when heads are full size but before bolting (flowering). Cut at the base.',
          ],
          'mr': [
            'अंकुरण: रॉकवूल क्यूब्स किंवा पीट प्लगमध्ये बियाणे पेरा. ओलावा आणि उबदार ठेवा.',
            'रोपटे अवस्था: खरी पाने दिसू लागल्यावर (१०-१४ दिवस), हायड्रोपोनिक सिस्टम (NFT किंवा DWC) मध्ये पुनर्लावणी करा.',
            'वाढ: pH ६.० आणि EC १.० च्या आसपास ठेवा. पुरेसा प्रकाश (१२-१४ तास) असल्याची खात्री करा.',
            'काढणी: कोशिंबीर पूर्ण आकाराची झाल्यावर पण फुलोरा येण्यापूर्वी काढणी करा. बुडापासून कापा.',
          ],
          'hi': [
            'अंकुरण: रॉकवूल क्यूब या पीट प्लग में बीज बोएं। नम और गर्म रखें।',
            'पौध अवस्था: जब असली पत्ते दिखाई दें (१०-१४ दिन), तो हाइड्रोपोनिक सिस्टम (NFT या DWC) में ट्रांसप्लांट करें।',
            'विकास: pH ६.० और EC १.० के आसपास रखें। पर्याप्त प्रकाश (१२-१४ घंटे) सुनिश्चित करें।',
            'कटाई: जब सलाद पूरा आकार ले ले लेकिन फूल आने से पहले कटाई करें। आधार से काटें।',
          ],
        },
        tips: {
          'en': [
            'Prevent tip burn by ensuring good airflow.',
            'Lettuce loves cooler temperatures; high heat causes bolting.',
            'Harvest in the morning for crispest leaves.',
          ],
          'mr': [
            'चांगली हवा खेळती ठेवून पानांची टोके जळण्यापासून रोखा.',
            'लेट्यूसला थंड तापमान आवडते; जास्त उष्णतेमुळे फुलोरा येतो.',
            'पाने कुरकुरीत राहण्यासाठी सकाळी लवकर काढणी करा.',
          ],
          'hi': [
            'अच्छे वायु प्रवाह को सुनिश्चित करके पत्तियों की युक्तियों को जलने से रोकें।',
            'लेट्यूस को ठंडा तापमान पसंद है; अधिक गर्मी से फूल आ सकते हैं।',
            'पत्तियों को कुरकुरा रखने के लिए सुबह जल्दी कटाई करें।',
          ],
        },
      ),
    ),
    PlantKnowledge(
      id: 'spinach',
      name: {'en': 'Spinach', 'mr': 'पालक', 'hi': 'पालक'},
      scientificName: 'Spinacia oleracea',
      description: {
        'en':
            'Spinach is a nutrient-dense leafy green that thrives in cooler hydroponic environments.',
        'mr':
            'पालक ही पोषकतत्वांनी समृद्ध पालेभाजी आहे जी थंड हायड्रोपोनिक वातावरणात चांगली वाढते.',
        'hi':
            'पालक पोषक तत्वों से भरपूर पत्तेदार सब्जी है जो ठंडे हाइड्रोपोनिक वातावरण में अच्छी तरह बढ़ती है।',
      },
      nutritionalBenefits: {
        'en': [
          'Excellent source of Iron and Calcium',
          'High in Magnesium',
          'Packed with Vitamin C',
          'Promotes eye health',
        ],
        'mr': [
          'लोह आणि कॅल्शियमचा उत्कृष्ट स्रोत',
          'मॅग्नेशियमचे प्रमाण जास्त',
          'जीवनसत्त्व क ने भरपूर',
          'डोळ्यांच्या आरोग्यासाठी उत्तम',
        ],
        'hi': [
          'आयरन और कैल्शियम का उत्कृष्ट स्रोत',
          'मैग्नीशियम की उच्च मात्रा',
          'विटामिन सी से भरपूर',
          'आंखों के स्वास्थ्य को बढ़ावा देता है',
        ],
      },
      guide: HydroponicGuide(
        difficulty: {'en': 'Medium', 'mr': 'मध्यम', 'hi': 'मध्यम'},
        germinationTime: {
          'en': '5-10 days',
          'mr': '५-१० दिवस',
          'hi': '५-१० दिन',
        },
        harvestTime: {
          'en': '40-50 days',
          'mr': '४०-५० दिवस',
          'hi': '४०-५० दिन',
        },
        phRange: '5.5 - 6.5',
        ecRange: '1.0 - 1.6 mS/cm',
        temperatureRange: '10°C - 20°C',
        steps: {
          'en': [
            'Germination: Spinach seeds prefer cool temps to germinate. Pre-chilling seeds can help.',
            'Transplanting: Move carefully to the system to avoid damaging taproots.',
            'Growth: Keep water cool (below 20°C) to prevent root rot like Pythium.',
            'Harvest: Harvest outer leaves for continuous growth ("cut and come again") or the whole plant.',
          ],
          'mr': [
            'अंकुरण: पालकाच्या बिया थंड तापमानात अंकुरतात. बिया पेरण्यापूर्वी थंड करणे फायदेशीर ठरू शकते.',
            'पुनर्लावणी: मुळांना इजा न होऊ देता काळजीपूर्वक सिस्टममध्ये हलवा.',
            'वाढ: मुळे सडण्यापासून रोखण्यासाठी पाणी थंड (२०°C च्या खाली) ठेवा.',
            'काढणी: सतत उत्पादनासाठी बाहेरील पाने काढा किंवा पूर्ण झाड काढा.',
          ],
          'hi': [
            'अंकुरण: पालक के बीज ठंडे तापमान में अंकुरित होते हैं। बीज बोने से पहले उन्हें ठंडा करना फायदेमंद हो सकता है।',
            'ट्रांसप्लांटिंग: जड़ों को नुकसान से बचाने के लिए सावधानी से सिस्टम में ले जाएं।',
            'विकास: जड़ सड़न को रोकने के लिए पानी को ठंडा (२०°C से नीचे) रखें।',
            'कटाई: निरंतर उत्पादन के लिए बाहरी पत्तियों को काटें या पूरा पौधा काट लें।',
          ],
        },
        tips: {
          'en': [
            'Very sensitive to root rot; ensure high oxygen in water.',
            'Avoid overcrowding to prevent mildew.',
            'Use fresh seeds for better germination rates.',
          ],
          'mr': [
            'मुळांच्या कुजण्याबाबत अत्यंत संवेदनशील; पाण्यात ऑक्सिजनचे प्रमाण जास्त ठेवा.',
            'बुरशी टाळण्यासाठी झाडांमध्ये गर्दी टाळा.',
            'चांगल्या अंकुरणासाठी ताजी बियाणे वापरा.',
          ],
          'hi': [
            'जड़ सड़न के प्रति बहुत संवेदनशील; पानी में उच्च ऑक्सीजन सुनिश्चित करें।',
            'फफूंदी को रोकने के लिए भीड़भाड़ से बचें।',
            'बेहतर अंकुरण दर के लिए ताजे बीजों का उपयोग करें।',
          ],
        },
      ),
    ),
    PlantKnowledge(
      id: 'kale',
      name: {'en': 'Kale', 'mr': 'केल (Kale)', 'hi': 'केल (Kale)'},
      scientificName: 'Brassica oleracea',
      description: {
        'en':
            'A superfood that grows vigorously in hydroponics. It is hardy and produces abundant leaves.',
        'mr':
            'हे एक सुपरफूड आहे जे हायड्रोपोनिक्समध्ये जोमाने वाढते. हे कणखर आहे आणि भरपूर पाने देते.',
        'hi':
            'एक सुपरफूड जो हाइड्रोपोनिक्स में तेजी से बढ़ता है। यह कठोर है और प्रचुर मात्रा में पत्ते देता है।',
      },
      nutritionalBenefits: {
        'en': [
          'Extremely high in Vitamin K',
          'Good source of fiber',
          'Contains powerful antioxidants',
          'Anti-inflammatory properties',
        ],
        'mr': [
          'जीवनसत्त्व के चे प्रमाण अत्यंत जास्त',
          'फायबरचा चांगला स्रोत',
          'शक्तिशाली अँटिऑक्सिडंट्स असतात',
          'दाह कमी करणारे गुणधर्म',
        ],
        'hi': [
          'विटामिन के की अत्यधिक मात्रा',
          'फाइबर का अच्छा स्रोत',
          'शक्तिशाली एंटीऑक्सीडेंट होते हैं',
          'सूजन कम करने वाले गुण',
        ],
      },
      guide: HydroponicGuide(
        difficulty: {'en': 'Easy', 'mr': 'सोपे', 'hi': 'आसान'},
        germinationTime: {'en': '4-7 days', 'mr': '४-७ दिवस', 'hi': '४-७ दिन'},
        harvestTime: {
          'en': '50-65 days',
          'mr': '५०-६५ दिवस',
          'hi': '५०-६५ दिन',
        },
        phRange: '5.5 - 6.5',
        ecRange: '1.6 - 2.5 mS/cm',
        temperatureRange: '15°C - 24°C',
        steps: {
          'en': [
            'Start seeds in standard propagation plugs.',
            'Transplant to a system with good support as plants can get top-heavy.',
            'Kale is a heavy feeder; monitor EC levels regularly.',
            'Harvest older, outer leaves first to allow the center to keep producing.',
          ],
          'mr': [
            'प्रोपोगेशन प्लगमध्ये बियाणे पेरा.',
            'झाडे जड होऊ शकतात म्हणून चांगला आधार असलेल्या सिस्टममध्ये पुनर्लावणी करा.',
            'केलला जास्त पोषकतत्वे लागतात; EC पातळी नियमित तपासा.',
            'मध्यभाग सतत उत्पादन देत राहण्यासाठी जुनी, बाहेरील पाने आधी काढा.',
          ],
          'hi': [
            'प्रोपोगेशन प्लग में बीज बोएं।',
            'अच्छे आधार वाले सिस्टम में ट्रांसप्लांट करें क्योंकि पौधे भारी हो सकते हैं।',
            'केल को अधिक पोषक तत्वों की आवश्यकता होती है; नियमित रूप से EC स्तर की निगरानी करें।',
            'केंद्र को उत्पादन जारी रखने की अनुमति देने के लिए पहले पुरानी, ​​बाहरी पत्तियों की कटाई करें।',
          ],
        },
        tips: {
          'en': [
            'Kale gets sweeter after a light frost (or cooler temps).',
            'Watch for aphids and manage humidity.',
            'Can be grown in NFT, DWC, or Ebb & Flow systems.',
          ],
          'mr': [
            'थंड हवामानात केल अधिक गोड होतो.',
            'मावा किडीवर लक्ष ठेवा आणि आर्द्रता नियंत्रित करा.',
            'NFT, DWC किंवा Ebb & Flow सिस्टममध्ये वाढवता येते.',
          ],
          'hi': [
            'हल्की ठंड (या ठंडे तापमान) के बाद केल मीठा हो जाता है।',
            'एफिड्स पर नज़र रखें और आर्द्रता का प्रबंधन करें।',
            'NFT, DWC, या Ebb & Flow सिस्टम में उगाया जा सकता है।',
          ],
        },
      ),
    ),
    PlantKnowledge(
      id: 'basil',
      name: {'en': 'Basil', 'mr': 'तुळस (Basil)', 'hi': 'तुलसी (Basil)'},
      scientificName: 'Ocimum basilicum',
      description: {
        'en':
            'The king of herbs. Hydroponic basil grows much faster and more flavorful than soil-grown basil.',
        'mr':
            'औषधी वनस्पतींचा राजा. हायड्रोपोनिक तुळस मातीपेक्षा जास्त वेगाने वाढते आणि अधिक चवदार असते.',
        'hi':
            'जड़ी-बूटियों का राजा। हाइड्रोपोनिक तुलसी मिट्टी में उगाई जाने वाली तुलसी की तुलना में बहुत तेजी से और अधिक स्वादिष्ट होती है।',
      },
      nutritionalBenefits: {
        'en': [
          'Anti-bacterial properties',
          'Contains essential oils',
          'Rich in Vitamin K',
          'Good for digestion',
        ],
        'mr': [
          'बॅक्टेरियाविरोधी गुणधर्म',
          'आवश्यक तेले असतात',
          'जीवनसत्त्व के ने समृद्ध',
          'पचनासाठी चांगले',
        ],
        'hi': [
          'एंटी-बैक्टीरियल गुण',
          'आवश्यक तेल होते हैं',
          'विटामिन के से भरपूर',
          'पाचन के लिए अच्छा',
        ],
      },
      guide: HydroponicGuide(
        difficulty: {'en': 'Easy', 'mr': 'सोपे', 'hi': 'आसान'},
        germinationTime: {'en': '3-7 days', 'mr': '३-७ दिवस', 'hi': '३-७ दिन'},
        harvestTime: {
          'en': '25-35 days',
          'mr': '२५-३५ दिवस',
          'hi': '२५-३५ दिन',
        },
        phRange: '5.5 - 6.5',
        ecRange: '1.0 - 1.6 mS/cm',
        temperatureRange: '20°C - 27°C',
        steps: {
          'en': [
            'Germinates quickly in warm, humid conditions.',
            'Transplant early to avoid shock.',
            'Pruning is key: Pinch off the top tips to encourage bushy growth.',
            'Harvest leaves regularly to prevent flowering (which makes leaves bitter).',
          ],
          'mr': [
            'उबदार आणि दमट स्थितीत लवकर अंकुरते.',
            'शॉक टाळण्यासाठी लवकर पुनर्लावणी करा.',
            'छाटणी महत्त्वाची आहे: झाडे डेरेदार करण्यासाठी शेंडे खुडा.',
            'पाने कडू होऊ नयेत म्हणून फुलोरा येण्यापूर्वी नियमित काढणी करा.',
          ],
          'hi': [
            'गर्म और आर्द्र परिस्थितियों में जल्दी अंकुरित होता है।',
            'झटके से बचने के लिए जल्दी ट्रांसप्लांट करें।',
            'छंटाई महत्वपूर्ण है: झाड़ीदार विकास को प्रोत्साहित करने के लिए ऊपर की युक्तियों को चुटकी से काटें।',
            'फूल आने से रोकने के लिए नियमित रूप से पत्तियों की कटाई करें (जिससे पत्तियां कड़वी हो जाती हैं)।',
          ],
        },
        tips: {
          'en': [
            'Basil loves light! Give it 14-16 hours if possible.',
            'Keep temperatures warm; it hates the cold.',
            'Harvest from the top down.',
          ],
          'mr': [
            'तुळशीला प्रकाश आवडतो! शक्य असल्यास १४-१६ तास प्रकाश द्या.',
            'तापमान उबदार ठेवा; याला थंडी आवडत नाही.',
            'वरच्या बाजूने काढणी करा.',
          ],
          'hi': [
            'तुलसी को रोशनी पसंद है! यदि संभव हो तो इसे १४-१६ घंटे दें।',
            'तापमान गर्म रखें; इसे ठंड पसंद नहीं है।',
            'ऊपर से नीचे की ओर कटाई करें।',
          ],
        },
      ),
    ),
    PlantKnowledge(
      id: 'mint',
      name: {'en': 'Mint', 'mr': 'पुदिना (Mint)', 'hi': 'पुदीना (Mint)'},
      scientificName: 'Mentha',
      description: {
        'en':
            'A refreshing and aromatic herb that is very invasive in soil but manageable in hydroponics. Great for teas and garnishes.',
        'mr':
            'एक ताजी आणि सुगंधित औषधी वनस्पती जी मातीत खूप पसरते पण हायड्रोपोनिक्समध्ये नियंत्रित करता येते. चहा आणि सजावटीसाठी उत्तम.',
        'hi':
            'एक ताज़ा और सुगंधित जड़ी बूटी जो मिट्टी में बहुत आक्रामक होती है लेकिन हाइड्रोपोनिक्स में प्रबंधनीय होती है। चाय और गार्निश के लिए बढ़िया।',
      },
      nutritionalBenefits: {
        'en': [
          'Aids digestion',
          'Relieves nausea',
          'Contains menthol',
          'Rich in antioxidants',
        ],
        'mr': [
          'पचनास मदत करते',
          'मळमळ कमी करते',
          'मेंथॉल असते',
          'अँटिऑक्सिडंट्सने समृद्ध',
        ],
        'hi': [
          'पाचन में सहायता करता है',
          'मतली से राहत दिलाता है',
          'मेन्थॉल होता है',
          'एंटीऑक्सीडेंट से भरपूर',
        ],
      },
      guide: HydroponicGuide(
        difficulty: {'en': 'Easy', 'mr': 'सोपे', 'hi': 'आसान'},
        germinationTime: {
          'en': '10-15 days',
          'mr': '१०-१५ दिवस',
          'hi': '१०-१५ दिन',
        },
        harvestTime: {
          'en': '40-50 days',
          'mr': '४०-५० दिवस',
          'hi': '४०-५० दिन',
        },
        phRange: '5.5 - 6.0',
        ecRange: '2.0 - 2.4 mS/cm',
        temperatureRange: '18°C - 24°C',
        steps: {
          'en': [
            'Germination: Mint seeds are tiny; surface sow them. They take longer to germinate.',
            'Cuttings: Ideally, start from cuttings of a healthy plant for faster results.',
            'Growth: Mint grows essentially like a weed. Its roots will fill the system quickly.',
            'Harvest: Harvest frequently to keep it in check and encourage fresh growth.',
          ],
          'mr': [
            'अंकुरण: पुदिन्याच्या बिया खूप लहान असतात; त्या पृष्ठभागावर पेरा. अंकुरण्यास जास्त वेळ लागतो.',
            'कलम: जलद परिणामांसाठी, निरोगी झाडाच्या फांदीपासून (कलम) सुरुवात करा.',
            'वाढ: पुदिना तणासारखा वाढतो. त्याची मुळे सिस्टम लवकर भरून टाकतात.',
            'काढणी: वाढ नियंत्रित ठेवण्यासाठी आणि नवीन फूट येण्यासाठी वारंवार काढणी करा.',
          ],
          'hi': [
            'अंकुरण: पुदीने के बीज बहुत छोटे होते हैं; उन्हें सतह पर बोएं। वे अंकुरित होने में अधिक समय लेते हैं।',
            'कलम: तेजी से परिणाम के लिए, एक स्वस्थ पौधे की कलम से शुरुआत करना आदर्श है।',
            'विकास: पुदीना मूल रूप से खरपतवार की तरह बढ़ता है। इसकी जड़ें सिस्टम को जल्दी भर देंगी।',
            'कटाई: इसे नियंत्रण में रखने और नई वृद्धि को प्रोत्साहित करने के लिए बार-बार कटाई करें।',
          ],
        },
        tips: {
          'en': [
            'Isolate mint if possible, as roots can clog systems.',
            'Prune aggressive runners.',
            'Loves moisture and is hard to overwater.',
          ],
          'mr': [
            'शक्य असल्यास पुदिना वेगळा ठेवा, कारण मुळे सिस्टम चोक करू शकतात.',
            'अतिरिक्त वाढणाऱ्या फांद्या छाटा.',
            'याला ओलावा आवडतो आणि जास्त पाण्याने नुकसान होत नाही.',
          ],
          'hi': [
            'यदि संभव हो तो पुदीने को अलग रखें, क्योंकि जड़ें सिस्टम को रोक सकती हैं।',
            'आक्रामक धावकों (runners) की छंटाई करें।',
            'इसे नमी पसंद है और इसमें अधिक पानी देना मुश्किल है।',
          ],
        },
      ),
    ),
  ];
}
