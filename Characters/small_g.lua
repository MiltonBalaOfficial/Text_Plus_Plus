local strokesData = {
  [1] = {
    x = { 61.34636, 61.34636, 61.71014544, 62.04931072, 62.36666228, 62.66500656, 62.94715, 63.21589904, 63.47406012, 63.72443968, 63.96984416, 64.21308, 64.21308, 64.44401251, 64.65063608, 64.83295077, 64.99095664, 65.12465375, 65.23404216, 65.31912193, 65.37989312, 65.41635579, 65.42851, 65.42851, 65.41139471, 65.36004888, 65.27447257, 65.15466584, 65.00062875, 64.81236136, 64.58986373, 64.33313592, 64.04217799, 63.71699, 63.71699, 63.45678861, 63.18220048, 62.89322567, 62.58986424, 62.27211625, 61.93998176, 61.59346083, 61.23255352, 60.85725989, 60.46758, 60.46758, 60.10642319, 59.75717272, 59.41982853, 59.09439056, 58.78085875, 58.47923304, 58.18951337, 57.91169968, 57.64579191, 57.39179, 57.39179, 57.1561463, 56.9453072, 56.7592727, 56.5980428, 56.4616175, 56.3499968, 56.2631807, 56.2011692, 56.1639623, 56.15156, 56.15156, 56.1684272, 56.2190288, 56.3033648, 56.4214352, 56.57324, 56.7587792, 56.9780528, 57.2310608, 57.5178032, 57.83828, 57.83828, 58.10974067, 58.40631776, 58.72520489, 59.06359568, 59.41868375, 59.78766272, 60.16772621, 60.55606784, 60.94988123, 61.34636, 61.08211, 61.08211, 60.73653843, 60.37664984, 60.00565141, 59.62675032, 59.24315375, 58.85806888, 58.47470289, 58.09626296, 57.72595627, 57.36699, 57.36699, 57.15565259, 56.95820632, 56.77465113, 56.60498696, 56.44921375, 56.30733144, 56.17933997, 56.06523928, 55.96502931, 55.87871, 55.87871, 55.80801589, 55.74476352, 55.68895283, 55.64058376, 55.59965625, 55.56617024, 55.54012567, 55.52152248, 55.51036061, 55.50664, 55.50664, 55.5106087, 55.5225148, 55.5423583, 55.5701392, 55.6058575, 55.6495132, 55.7011063, 55.7606368, 55.8281047, 55.90351, 55.90351, 55.99553559, 56.10294032, 56.22572413, 56.36388696, 56.51742875, 56.68634944, 56.87064897, 57.07032728, 57.28538431, 57.51582, 57.51582, 57.6755619, 57.8769756, 58.1200611, 58.4048184, 58.7312475, 59.0993484, 59.5091211, 59.9605656, 60.4536819, 60.98847, 60.98847, 61.9744563, 62.8885092, 63.7306287, 64.5008148, 65.1990675, 65.8253868, 66.3797727, 66.8622252, 67.2727443, 67.61133, 67.61133, 68.06327102, 68.49636016, 68.91059754, 69.30598328, 69.6825175, 70.04020032, 70.37903186, 70.69901224, 71.00014158, 71.28242, 71.28242, 71.5463414, 71.7824816, 71.9908406, 72.1714184, 72.324215, 72.4492304, 72.5464646, 72.6159176, 72.6575894, 72.67148, 72.67148, 72.64518709, 72.56630832, 72.43484363, 72.25079296, 72.01415625, 71.72493344, 71.38312447, 70.98872928, 70.54174781, 70.04218, 70.04218, 69.24470888, 68.40010944, 67.50838156, 66.56952512, 65.58354, 64.55042608, 63.47018324, 62.34281136, 61.16831032, 59.94668, 59.94668, 59.00410099, 58.09128792, 57.20824073, 56.35495936, 55.53144375, 54.73769384, 53.97370957, 53.23949088, 52.53503771, 51.86035, 51.86035, 51.50688431, 51.19062528, 50.91157297, 50.66972744, 50.46508875, 50.29765696, 50.16743213, 50.07441432, 50.01860359, 50, 50, 50.00272985, 50.0109188, 50.02456595, 50.0436704, 50.06823125, 50.0982476, 50.13371855, 50.1746432, 50.22102065, 50.27285, 50.27285, 50.36611579, 50.47724112, 50.60622593, 50.75307016, 50.91777375, 51.10033664, 51.30075877, 51.51904008, 51.75518051, 52.00918, 52.00918, 52.0816359, 52.22501, 52.4324869, 52.6972512, 53.0124875, 53.3713804, 53.7671145, 54.1928744, 54.6418447, 55.10721, 55.8701, 55.8701, 55.6435773, 55.430068, 55.2291713, 55.0404864, 54.8636125, 54.6981488, 54.5436945, 54.3998488, 54.2662109, 54.14238, 54.14238, 54.02927191, 53.92806968, 53.83877337, 53.76138304, 53.69589875, 53.64232056, 53.60064853, 53.57088272, 53.55302319, 53.54707, 53.54707, 53.56145679, 53.60461712, 53.67655093, 53.77725816, 53.90673875, 54.06499264, 54.25201977, 54.46782008, 54.71239351, 54.98574, 54.98574, 55.50391082, 56.06623336, 56.67270774, 57.32333408, 58.0181125, 58.75704312, 59.54012606, 60.36736144, 61.23874938, 62.15429, 62.15429, 63.02369631, 63.84597328, 64.62112097, 65.34913944, 66.03002875, 66.66378896, 67.25042013, 67.78992232, 68.28229559, 68.72754, 68.72754, 69.13284719, 69.49549072, 69.81547053, 70.09278656, 70.32743875, 70.51942704, 70.66875137, 70.77541168, 70.83940791, 70.86074, 70.86074, 70.8480896, 70.8101384, 70.7468864, 70.6583336, 70.54448, 70.4053256, 70.2408704, 70.0511144, 69.8360576, 69.5957, 69.5957, 69.31243191, 68.97856168, 68.59408937, 68.15901504, 67.67333875, 67.13706056, 66.55018053, 65.91269872, 65.22461519, 64.48593, 64.48593, 63.3945172, 62.3487008, 61.3424838, 60.3698692, 59.42486, 58.5014592, 57.5936698, 56.6954948, 55.8009372, 54.904, 54.904, 54.40037785, 53.9960812, 53.67749575, 53.4310072, 53.24300125, 53.0998636, 52.98797995, 52.893736, 52.80351745, 52.70371, 52.70371, 52.60473819, 52.51618472, 52.43804953, 52.37033256, 52.31303375, 52.26615304, 52.22969037, 52.20364568, 52.18801891, 52.18281, 52.18281, 52.1897553, 52.2105912, 52.2453177, 52.2939348, 52.3564425, 52.4328408, 52.5231297, 52.6273092, 52.7453793, 52.87734, 52.87734, 53.03956349, 53.23849792, 53.47414323, 53.74649936, 54.05556625, 54.40134384, 54.78383207, 55.20303088, 55.65894021, 56.15156, 56.15156, 56.15156, 55.7445158, 55.3568192, 54.9884702, 54.6394688, 54.309815, 53.9995088, 53.7085502, 53.4369392, 53.1846758, 52.95176, 52.95176, 52.73967739, 52.54991952, 52.38248633, 52.23737776, 52.11459375, 52.01413424, 51.93599917, 51.88018848, 51.84670211, 51.83554, 51.83554, 51.8608408, 51.9367432, 52.0632472, 52.2403528, 52.46806, 52.7463688, 53.0752792, 53.4547912, 53.8849048, 54.36562, 54.36562, 54.89073669, 55.44413072, 56.02580203, 56.63575056, 57.27397625, 57.94047904, 58.63525887, 59.35831568, 60.10964941, 60.88926, 60.88926, 61.53045959, 62.15429632, 62.76077013, 63.34988096, 63.92162875, 64.47601344, 65.01303497, 65.53269328, 66.03498831, 66.51992, 71.33203, 71.33203, 71.5364212, 71.7229528, 71.8916248, 72.0424372, 72.17539, 72.2904832, 72.3877168, 72.4670908, 72.5286052, 72.57226, 72.57226, 72.60599561, 72.63774648, 72.66751267, 72.69529424, 72.72109125, 72.74490376, 72.76673183, 72.78657552, 72.80443489, 72.82031, 72.82031, 72.84858284, 72.87388112, 72.89620448, 72.91555256, 72.931925, 72.94532144, 72.95574152, 72.96318488, 72.96765116, 72.96914, 72.96914, 72.96790087, 72.96418296, 72.95798549, 72.94930768, 72.93814875, 72.92450792, 72.90838441, 72.88977744, 72.86868623, 72.84511, 72.84511, 72.8289895, 72.810388, 72.7893055, 72.765742, 72.7396975, 72.711172, 72.6801655, 72.646678, 72.6107095, 72.57226, 72.57226, 72.5286052, 72.4670908, 72.3877168, 72.2904832, 72.17539, 72.0424372, 71.8916248, 71.7229528, 71.5364212, 71.33203, 68.38027, 68.38027, 68.6441914, 68.8803316, 69.0886906, 69.2692684, 69.422065, 69.5470804, 69.6443146, 69.7137676, 69.7554394, 69.76933, 69.76933, 69.74502131, 69.67209528, 69.55055197, 69.38039144, 69.16161375, 68.89421896, 68.57820713, 68.21357832, 67.80033259, 67.33847, 67.33847, 66.84316318, 66.32744664, 65.78811326, 65.22195592, 64.6257675, 63.99634088, 63.33046894, 62.62494456, 61.87656062, 61.08211, 61.34636 },
    y = { 90.80887488555, 90.80887488555, 90.79847799755, 90.76621826155, 90.71049206955, 90.62969581355, 90.52222588555, 90.38647867755, 90.22085058155, 90.02373798955, 89.79353729355, 89.52864488555, 89.52864488555, 89.22974846155, 88.89860597355, 88.53521739755, 88.13958270955, 87.71170188555, 87.25157490155, 86.75920173355, 86.23458235755, 85.67771674955, 85.08860488555, 85.08860488555, 84.31693018555, 83.57948608555, 82.87627258555, 82.20728968555, 81.57253738555, 80.97201568555, 80.40572458555, 79.87366408555, 79.37583418555, 78.91223488555, 78.91223488555, 78.60118317555, 78.32287400555, 78.07730731555, 77.86448304555, 77.68440113555, 77.53706152555, 77.42246415555, 77.34060896555, 77.29149589555, 77.27512488555, 77.27512488555, 77.28975964055, 77.33366392555, 77.40683777055, 77.50928120555, 77.64099426055, 77.80197696555, 77.99222935055, 78.21175144555, 78.46054328055, 78.73860488555, 78.73860488555, 79.04692712855, 79.38650326955, 79.75733332655, 80.15941731755, 80.59275526055, 81.05734717355, 81.55319307455, 82.08029298155, 82.63864691255, 83.22825488555, 83.22825488555, 83.99447167555, 84.72546600555, 85.42123781555, 86.08178704555, 86.70711363555, 87.29721752555, 87.85209865555, 88.37175696555, 88.85619239555, 89.30540488555, 89.30540488555, 89.61271467555, 89.88086720555, 90.11146621555, 90.30611544555, 90.46641863555, 90.59397952555, 90.69040185555, 90.75728936555, 90.79624579555, 90.80887488555, 92.05770488555, 92.05770488555, 92.05555023855, 92.04828450955, 92.03470501655, 92.01360907755, 91.98379401055, 91.94405713355, 91.89319576455, 91.83000722155, 91.75328882255, 91.66183788555, 91.66183788555, 91.84812107055, 92.02993956555, 92.20729328055, 92.38018212555, 92.54860601055, 92.71256484555, 92.87205854055, 93.02708700555, 93.17765015055, 93.32374788555, 93.32374788555, 93.46066980055, 93.59362292555, 93.72260723055, 93.84762268555, 93.96866926055, 94.08574692555, 94.19885565055, 94.30799540555, 94.41316616055, 94.51436788555, 94.51436788555, 94.59845584455, 94.68204771755, 94.76514349855, 94.84774318155, 94.92984676055, 95.01145422955, 95.09256558255, 95.17318081355, 95.25329991655, 95.33292288555, 95.33292288555, 95.41006539355, 95.48274310955, 95.55095602155, 95.61470411755, 95.67398738555, 95.72880581355, 95.77915938955, 95.82504810155, 95.86647193755, 95.90343088555, 95.90343088555, 95.92302761655, 95.94212785355, 95.96073166255, 95.97883910955, 95.99645026055, 96.01356518155, 96.03018393855, 96.04630659755, 96.06193322455, 96.07706388555, 96.07706388555, 96.10286018955, 96.13064107755, 96.16040651355, 96.19215646155, 96.22589088555, 96.26160974955, 96.29931301755, 96.33900065355, 96.38067262155, 96.42432888555, 96.42432888555, 96.49948710155, 96.59597733355, 96.71379955755, 96.85295374955, 97.01343988555, 97.19525794155, 97.39840789355, 97.62288971755, 97.86870338955, 98.13584888555, 98.13584888555, 98.42011051855, 98.71727078955, 99.02732965655, 99.35028707755, 99.68614301055, 100.03489741355, 100.39655024455, 100.77110146155, 101.15855102255, 101.55889888555, 101.55889888555, 102.11601209555, 102.66617976555, 103.20940195555, 103.74567872555, 104.27501013555, 104.79739624555, 105.31283711555, 105.82133280555, 106.32288337555, 106.81748888555, 106.81748888555, 107.50557008555, 108.12122168555, 108.66444368555, 109.13523608555, 109.53359888555, 109.85953208555, 110.11303568555, 110.29410968555, 110.40275408555, 110.43896888555, 110.43896888555, 110.41738880355, 110.35264854955, 110.24474811155, 110.09368747755, 109.89946663555, 109.66208557355, 109.38154427955, 109.05784274155, 108.69098094755, 108.28095888555, 108.28095888555, 108.03191976655, 107.78089621355, 107.52788823255, 107.27289582955, 107.01591901055, 106.75695778155, 106.49601214855, 106.23308211755, 105.96816769455, 105.70126888555, 105.70126888555, 105.58220639055, 105.46314392555, 105.34408152055, 105.22501920555, 105.10595701055, 104.98689496555, 104.86783310055, 104.74877144555, 104.62971003055, 104.51064888555, 104.51064888555, 104.31990073855, 104.11476574955, 103.89524399655, 103.66133555755, 103.41304051055, 103.15035893355, 102.87329090455, 102.58183650155, 102.27599580255, 101.95576888555, 101.95576888555, 101.87382906155, 101.72158277355, 101.50544459755, 101.23182910955, 100.90715088555, 100.53782450155, 100.13026453355, 99.69088555755, 99.22610214955, 98.74232888555, 99.37508788555, 99.37508788555, 99.62916568255, 99.88458182155, 100.14013352455, 100.39461801355, 100.64683251055, 100.89557423755, 101.13964041655, 101.37782826955, 101.60893501855, 101.83175788555, 101.83175788555, 102.04830274755, 102.26137494155, 102.47097447955, 102.67710137355, 102.87975563555, 103.07893727755, 103.27464631155, 103.46688274955, 103.65564660355, 103.84093788555, 103.84093788555, 104.07608628555, 104.30528148555, 104.52852348555, 104.74581228555, 104.95714788555, 105.16253028555, 105.36195948555, 105.55543548555, 105.74295828555, 105.92452788555, 105.92452788555, 106.21672698555, 106.47816828555, 106.70885178555, 106.90877748555, 107.07794538555, 107.21635548555, 107.32400778555, 107.40090228555, 107.44703898555, 107.46241788555, 107.46241788555, 107.44654287655, 107.39891785355, 107.31954282255, 107.20841778955, 107.06554276055, 106.89091774155, 106.68454273855, 106.44641775755, 106.17654280455, 105.87491788555, 105.87491788555, 105.56014558555, 105.24090868555, 104.91720718555, 104.58904108555, 104.25641038555, 103.91931508555, 103.57775518555, 103.23173068555, 102.88124158555, 102.52628788555, 102.52628788555, 102.27576087055, 102.04011676555, 101.81935548055, 101.61347692555, 101.42248101055, 101.24636764555, 101.08513674055, 100.93878820555, 100.80732195055, 100.69073788555, 100.69073788555, 100.58606212655, 100.49031605355, 100.40349967255, 100.32561298955, 100.25665601055, 100.19662874155, 100.14553118855, 100.10336335755, 100.07012525455, 100.04581688555, 100.04581688555, 100.01307285255, 99.97337450155, 99.92522445455, 99.86712533355, 99.79757976055, 99.71509035755, 99.61815974655, 99.50529054955, 99.37498538855, 99.22574688555, 99.22574688555, 99.01448188055, 98.83459840555, 98.68099097055, 98.54855408555, 98.43218226055, 98.32677000555, 98.22721183055, 98.12840224555, 98.02523576055, 97.91260688555, 97.91260688555, 97.78709528855, 97.65860710955, 97.52714236655, 97.39270107755, 97.25528326055, 97.11488893355, 96.97151811455, 96.82517082155, 96.67584707255, 96.52354688555, 96.52354688555, 96.34693754755, 96.16437514155, 95.97585967955, 95.78139117355, 95.58096963555, 95.37459507755, 95.16226751155, 94.94398694955, 94.71975340355, 94.48956688555, 94.48956688555, 94.24672883355, 93.98454310955, 93.70300976155, 93.40212883755, 93.08190038555, 92.74232445355, 92.38340108955, 92.00513034155, 91.60751225755, 91.19054688555, 91.19055488555, 91.19055488555, 90.97921898055, 90.75200824555, 90.50892265055, 90.24996216555, 89.97512676055, 89.68441640555, 89.37783107055, 89.05537072555, 88.71703534055, 88.36282488555, 88.36282488555, 87.99199428555, 87.61372248555, 87.22800948555, 86.83485528555, 86.43425988555, 86.02622328555, 85.61074548555, 85.18782648555, 84.75746628555, 84.31966488555, 84.31966488555, 83.65440286555, 83.00799272555, 82.38043434555, 81.77172760555, 81.18187238555, 80.61086856555, 80.05871602555, 79.52541464555, 79.01096430555, 78.51536488555, 78.51536488555, 78.05350229555, 77.64025656555, 77.27562775555, 76.95961592555, 76.69222113555, 76.47344344555, 76.30328291555, 76.18173960555, 76.10881357555, 76.08450488555, 76.08450488555, 76.10037989455, 76.14800491755, 76.22737994855, 76.33850498155, 76.48138001055, 76.65600502955, 76.86238003255, 77.10050501355, 77.37037996655, 77.67200488555, 77.67200488555, 77.67200488555, 77.67274889555, 77.67498096555, 77.67870115555, 77.68390952555, 77.69060613555, 77.69879104555, 77.70846431555, 77.71962600555, 77.73227617555, 77.74641488555, 77.74641488555, 77.75732827255, 77.77022638155, 77.78510913455, 77.80197645355, 77.82082826055, 77.84166447755, 77.86448502655, 77.88928982955, 77.91607880855, 77.94485188555, 77.94485188555, 77.99297320655, 78.04803977355, 78.11005159255, 78.17900866955, 78.25491101055, 78.33775862155, 78.42755150855, 78.52428967755, 78.62797313455, 78.73860188555, 78.73860188555, 78.86361752655, 78.98069565355, 79.08983627255, 79.19103938955, 79.28430501055, 79.36963314155, 79.44702378855, 79.51647695755, 79.57799265455, 79.63157088555, 79.63157088555, 79.65587894655, 79.67919509355, 79.70151927255, 79.72285142955, 79.74319151055, 79.76253946155, 79.78089522855, 79.79825875755, 79.81462999455, 79.83000888555, 79.83000888555, 79.84414759555, 79.85679776555, 79.86795945555, 79.87763272555, 79.88581763555, 79.89251424555, 79.89772261555, 79.90144280555, 79.90367487555, 79.90441888555, 79.90441888555, 79.90441888555, 80.27152706555, 80.65847952555, 81.06527614555, 81.49191680555, 81.93840138555, 82.40472976555, 82.89090182555, 83.39691744555, 83.92277650555, 84.46847888555, 84.46847888555, 85.09430199555, 85.70176936555, 86.29088105555, 86.86163712555, 87.41403763555, 87.94808264555, 88.46377221555, 88.96110640555, 89.44008527555, 89.90070888555, 89.90070888555, 90.32677614555, 90.70288776555, 91.03024650555, 91.31005512555, 91.54351638555, 91.73183304555, 91.87620786555, 91.97784360555, 92.03794302555, 92.05770888555, 90.80887488555 },
    pressure = {},
    tool = "pen",
    color = 16711680,
    width = 0.00,
    fill = 255,
    lineStyle = "plain",
  },
}
return strokesData   -- Return the strokesData table