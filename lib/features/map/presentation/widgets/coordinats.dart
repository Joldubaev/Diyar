class Coordinate {
  final double latitude;
  final double longitude;

  Coordinate({required this.latitude, required this.longitude});
}

class DeliveryPolygon {
  final List<Coordinate> coordinates;
  final double deliveryPrice;
  final int id;

  DeliveryPolygon({
    required this.id,
    required this.coordinates,
    required this.deliveryPrice,
  });
}

class Polygons {
  static List<DeliveryPolygon> getPolygons() {
    return [
      DeliveryPolygon(
        id: 1,
        coordinates: [
          Coordinate(
            latitude: 42.89116735462305,
            longitude: 74.64982253738371,
          ),
          Coordinate(
            latitude: 42.890362682119964,
            longitude: 74.64971524902313,
          ),
          Coordinate(
            latitude: 42.888485071825826,
            longitude: 74.64969379135098,
          ),
          Coordinate(
            latitude: 42.886465393177744,
            longitude: 74.64950067230188,
          ),
          Coordinate(
            latitude: 42.883877582508156,
            longitude: 74.64962941833461,
          ),
          Coordinate(
            latitude: 42.884414088826254,
            longitude: 74.6560452622982,
          ),
          Coordinate(
            latitude: 42.883940701142436,
            longitude: 74.6626542253109,
          ),
          Coordinate(
            latitude: 42.882915015325736,
            longitude: 74.67158061691242,
          ),
          Coordinate(
            latitude: 42.88228381551122,
            longitude: 74.67778188415485,
          ),
          Coordinate(
            latitude: 42.88214179465101,
            longitude: 74.67855436035111,
          ),
          Coordinate(
            latitude: 42.88561332132493,
            longitude: 74.679069344482,
          ),
          Coordinate(
            latitude: 42.885818450835245,
            longitude: 74.67857581802328,
          ),
          Coordinate(
            latitude: 42.88815372298081,
            longitude: 74.67898351379353,
          ),
          Coordinate(
            latitude: 42.888879532670664,
            longitude: 74.6792195481868,
          ),
          Coordinate(
            latitude: 42.88922665600327,
            longitude: 74.67763168045002,
          ),
          Coordinate(
            latitude: 42.89195623916746,
            longitude: 74.66065866180371,
          ),
          Coordinate(
            latitude: 42.89184579599564,
            longitude: 74.65793353744462,
          ),
          Coordinate(
            latitude: 42.89162490900481,
            longitude: 74.65574485488843,
          ),
          Coordinate(
            latitude: 42.89162490900481,
            longitude: 74.65347034164381,
          ),
          Coordinate(
            latitude: 42.89219290251425,
            longitude: 74.65149623580886,
          ),
          Coordinate(
            latitude: 42.8924374537023,
            longitude: 74.65138894744824,
          ),
          Coordinate(
            latitude: 42.8930922145726,
            longitude: 74.65001565643277,
          ),
        ],
        deliveryPrice: 120,
      ),
      DeliveryPolygon(
        id: 2,
        coordinates: [
          Coordinate(
            latitude: 42.894275500392865,
            longitude: 74.63419062324456,
          ),
          Coordinate(
            latitude: 42.87980155437923,
            longitude: 74.63737120515667,
          ),
          Coordinate(
            latitude: 42.8777815893341,
            longitude: 74.6376823414024,
          ),
          Coordinate(
            latitude: 42.87729236900627,
            longitude: 74.63755359536972,
          ),
          Coordinate(
            latitude: 42.876163991153085,
            longitude: 74.63704934007488,
          ),
          Coordinate(
            latitude: 42.87513817507068,
            longitude: 74.6371566284355,
          ),
          Coordinate(
            latitude: 42.875059265355354,
            longitude: 74.64166273958054,
          ),
          Coordinate(
            latitude: 42.875106611127215,
            longitude: 74.65773453599785,
          ),
          Coordinate(
            latitude: 42.87521708451053,
            longitude: 74.66550221330496,
          ),
          Coordinate(
            latitude: 42.875075047242,
            longitude: 74.66882815248341,
          ),
          Coordinate(
            latitude: 42.8745542411979,
            longitude: 74.67646708375783,
          ),
          Coordinate(
            latitude: 42.874207034684225,
            longitude: 74.67805495149472,
          ),
          Coordinate(
            latitude: 42.87359152743678,
            longitude: 74.68382706529474,
          ),
          Coordinate(
            latitude: 42.872865536557406,
            longitude: 74.68820443040707,
          ),
          Coordinate(
            latitude: 42.872044840885586,
            longitude: 74.69060768968437,
          ),
          Coordinate(
            latitude: 42.87362309203661,
            longitude: 74.69086518174984,
          ),
          Coordinate(
            latitude: 42.872392059626684,
            longitude: 74.6967874992547,
          ),
          Coordinate(
            latitude: 42.87580101184257,
            longitude: 74.6973453987298,
          ),
          Coordinate(
            latitude: 42.88129281373642,
            longitude: 74.69811787492611,
          ),
          Coordinate(
            latitude: 42.88403853006674,
            longitude: 74.6982466209588,
          ),
          Coordinate(
            latitude: 42.88845666575074,
            longitude: 74.68972792512753,
          ),
          Coordinate(
            latitude: 42.887454723458596,
            longitude: 74.68518426305647,
          ),
          Coordinate(
            latitude: 42.88745472343378,
            longitude: 74.68356420881149,
          ),
          Coordinate(
            latitude: 42.888870849409784,
            longitude: 74.67927803880575,
          ),
          Coordinate(
            latitude: 42.88582949107354,
            longitude: 74.67865576631428,
          ),
          Coordinate(
            latitude: 42.88563225118323,
            longitude: 74.67911174184678,
          ),
          Coordinate(
            latitude: 42.884405404932245,
            longitude: 74.67891325837965,
          ),
          Coordinate(
            latitude: 42.88209366000783,
            longitude: 74.67856457120779,
          ),
          Coordinate(
            latitude: 42.882559171939214,
            longitude: 74.67507769948838,
          ),
          Coordinate(
            latitude: 42.88291027604941,
            longitude: 74.67135479337573,
          ),
          Coordinate(
            latitude: 42.8830641300114,
            longitude: 74.66988494283558,
          ),
          Coordinate(
            latitude: 42.88342706604054,
            longitude: 74.66682722455865,
          ),
          Coordinate(
            latitude: 42.88381366947339,
            longitude: 74.66361393815885,
          ),
          Coordinate(
            latitude: 42.88399119062693,
            longitude: 74.6614145267666,
          ),
          Coordinate(
            latitude: 42.88432650697968,
            longitude: 74.65608765966309,
          ),
          Coordinate(
            latitude: 42.88420421531216,
            longitude: 74.65399017221354,
          ),
          Coordinate(
            latitude: 42.88397541091301,
            longitude: 74.65090026742836,
          ),
          Coordinate(
            latitude: 42.88391623722881,
            longitude: 74.65027263051886,
          ),
          Coordinate(
            latitude: 42.88386495332294,
            longitude: 74.64974155313394,
          ),
          Coordinate(
            latitude: 42.88378605492236,
            longitude: 74.6495430696668,
          ),
          Coordinate(
            latitude: 42.88407877351088,
            longitude: 74.64954358764552,
          ),
          Coordinate(
            latitude: 42.88642200147026,
            longitude: 74.64950067230127,
          ),
          Coordinate(
            latitude: 42.888694136906985,
            longitude: 74.64969379135042,
          ),
          Coordinate(
            latitude: 42.889893285501316,
            longitude: 74.64971524902252,
          ),
          Coordinate(
            latitude: 42.890638796958456,
            longitude: 74.64972061344055,
          ),
          Coordinate(
            latitude: 42.89107663277993,
            longitude: 74.64976352878482,
          ),
          Coordinate(
            latitude: 42.891321188376466,
            longitude: 74.649790350875,
          ),
          Coordinate(
            latitude: 42.89156968741767,
            longitude: 74.64986008830934,
          ),
          Coordinate(
            latitude: 42.89183199074319,
            longitude: 74.6498600883095,
          ),
          Coordinate(
            latitude: 42.89222840206996,
            longitude: 74.64976352878497,
          ),
          Coordinate(
            latitude: 42.892756946546754,
            longitude: 74.64984399505542,
          ),
          Coordinate(
            latitude: 42.89312376948435,
            longitude: 74.65006930061267,
          ),
          Coordinate(
            latitude: 42.893376205515295,
            longitude: 74.64893204399037,
          ),
          Coordinate(
            latitude: 42.893439314360414,
            longitude: 74.64822394081042,
          ),
          Coordinate(
            latitude: 42.89288710976015,
            longitude: 74.64633566566397,
          ),
          Coordinate(
            latitude: 42.892303345196346,
            longitude: 74.64442593284535,
          ),
          Coordinate(
            latitude: 42.89231912269016,
            longitude: 74.64365345664909,
          ),
          Coordinate(
            latitude: 42.8925873394631,
            longitude: 74.64260203071525,
          ),
          Coordinate(
            latitude: 42.89407039923419,
            longitude: 74.63893276878285,
          ),
          Coordinate(
            latitude: 42.894449047036275,
            longitude: 74.63785988517691,
          ),
          Coordinate(
            latitude: 42.89454370862092,
            longitude: 74.63693720527576,
          ),
          Coordinate(
            latitude: 42.894449047011484,
            longitude: 74.63545662589961,
          ),
          Coordinate(
            latitude: 42.894275500392865,
            longitude: 74.63419062324456,
          ),
        ],
        deliveryPrice: 180,
      ),
      DeliveryPolygon(
        id: 3,
        coordinates: [
          Coordinate(
            latitude: 42.895886076076785,
            longitude: 74.61157517835974,
          ),
          Coordinate(
            latitude: 42.88511293339427,
            longitude: 74.61183406082856,
          ),
          Coordinate(
            latitude: 42.87779087810609,
            longitude: 74.61200572220551,
          ),
          Coordinate(
            latitude: 42.867184970515986,
            longitude: 74.61123324600919,
          ),
          Coordinate(
            latitude: 42.86282844094365,
            longitude: 74.61063243118988,
          ),
          Coordinate(
            latitude: 42.86257587900871,
            longitude: 74.61380816666349,
          ),
          Coordinate(
            latitude: 42.86314414189891,
            longitude: 74.61638308731779,
          ),
          Coordinate(
            latitude: 42.865480278431136,
            longitude: 74.62573863236173,
          ),
          Coordinate(
            latitude: 42.86689765314075,
            longitude: 74.63635878965711,
          ),
          Coordinate(
            latitude: 42.86771841774837,
            longitude: 74.64322524473523,
          ),
          Coordinate(
            latitude: 42.86677138068704,
            longitude: 74.64931922361703,
          ),
          Coordinate(
            latitude: 42.867023925334294,
            longitude: 74.66039138243053,
          ),
          Coordinate(
            latitude: 42.86809722847531,
            longitude: 74.66330962583874,
          ),
          Coordinate(
            latitude: 42.867023925334294,
            longitude: 74.69129043028208,
          ),
          Coordinate(
            latitude: 42.86664510797316,
            longitude: 74.70124679014538,
          ),
          Coordinate(
            latitude: 42.86866544015058,
            longitude: 74.70083909437511,
          ),
          Coordinate(
            latitude: 42.87104871516628,
            longitude: 74.70032411024422,
          ),
          Coordinate(
            latitude: 42.87085931921758,
            longitude: 74.6991439382777,
          ),
          Coordinate(
            latitude: 42.87128545927897,
            longitude: 74.6980066816554,
          ),
          Coordinate(
            latitude: 42.87202725157586,
            longitude: 74.69811397001598,
          ),
          Coordinate(
            latitude: 42.87216929583521,
            longitude: 74.69723420545914,
          ),
          Coordinate(
            latitude: 42.87352659151553,
            longitude: 74.69096856520034,
          ),
          Coordinate(
            latitude: 42.871822075831815,
            longitude: 74.69105439588881,
          ),
          Coordinate(
            latitude: 42.87207459966578,
            longitude: 74.68985276625014,
          ),
          Coordinate(
            latitude: 42.8732109440403,
            longitude: 74.6853466551051,
          ),
          Coordinate(
            latitude: 42.8743157030648,
            longitude: 74.67702107832295,
          ),
          Coordinate(
            latitude: 42.87504167671231,
            longitude: 74.6667213957058,
          ),
          Coordinate(
            latitude: 42.874852293030855,
            longitude: 74.63685231611605,
          ),
          Coordinate(
            latitude: 42.87785079806615,
            longitude: 74.63771062300079,
          ),
          Coordinate(
            latitude: 42.88804461742116,
            longitude: 74.6353717367398,
          ),
          Coordinate(
            latitude: 42.89194180589048,
            longitude: 74.63432031080602,
          ),
          Coordinate(
            latitude: 42.89430839848216,
            longitude: 74.63427739546181,
          ),
          Coordinate(
            latitude: 42.8943715063665,
            longitude: 74.63329034254434,
          ),
          Coordinate(
            latitude: 42.89487636709948,
            longitude: 74.63174539015176,
          ),
          Coordinate(
            latitude: 42.895097242361125,
            longitude: 74.63050084516883,
          ),
          Coordinate(
            latitude: 42.89519190294364,
            longitude: 74.62925630018594,
          ),
          Coordinate(
            latitude: 42.89399285808486,
            longitude: 74.62745385572795,
          ),
          Coordinate(
            latitude: 42.893487990066845,
            longitude: 74.62646680281043,
          ),
          Coordinate(
            latitude: 42.893361772411886,
            longitude: 74.62517934248328,
          ),
          Coordinate(
            latitude: 42.89399285808486,
            longitude: 74.62183194563272,
          ),
          Coordinate(
            latitude: 42.89490792075707,
            longitude: 74.61638169691444,
          ),
          Coordinate(
            latitude: 42.895886076076785,
            longitude: 74.61157517835974,
          ),
        ],
        deliveryPrice: 220,
      ),
      DeliveryPolygon(
        id: 4,
        coordinates: [
          Coordinate(
            latitude: 42.86666675615488,
            longitude: 74.69987451540884,
          ),
          Coordinate(
            latitude: 42.866642313118014,
            longitude: 74.70137579469095,
          ),
          Coordinate(
            latitude: 42.86695799440446,
            longitude: 74.69403727082621,
          ),
          Coordinate(
            latitude: 42.867778758179114,
            longitude: 74.66738684205427,
          ),
          Coordinate(
            latitude: 42.86765248754079,
            longitude: 74.66270906953231,
          ),
          Coordinate(
            latitude: 42.8669895624213,
            longitude: 74.66043455628764,
          ),
          Coordinate(
            latitude: 42.8669579943796,
            longitude: 74.65545637635604,
          ),
          Coordinate(
            latitude: 42.866768585763104,
            longitude: 74.64953405885117,
          ),
          Coordinate(
            latitude: 42.86771562286764,
            longitude: 74.64301092652696,
          ),
          Coordinate(
            latitude: 42.86711583440063,
            longitude: 74.63773233918563,
          ),
          Coordinate(
            latitude: 42.866295061723,
            longitude: 74.63142378358262,
          ),
          Coordinate(
            latitude: 42.864827114793535,
            longitude: 74.62299091843927,
          ),
          Coordinate(
            latitude: 42.86255409403504,
            longitude: 74.6124766591008,
          ),
          Coordinate(
            latitude: 42.8627750858635,
            longitude: 74.6094725850041,
          ),
          Coordinate(
            latitude: 42.85696589302041,
            longitude: 74.60882885484062,
          ),
          Coordinate(
            latitude: 42.85627127877004,
            longitude: 74.62612373856886,
          ),
          Coordinate(
            latitude: 42.8561839637383,
            longitude: 74.63859047275267,
          ),
          Coordinate(
            latitude: 42.8559313744273,
            longitude: 74.64532818179815,
          ),
          Coordinate(
            latitude: 42.855410405661914,
            longitude: 74.64833225589501,
          ),
          Coordinate(
            latitude: 42.855584062276364,
            longitude: 74.65768780093912,
          ),
          Coordinate(
            latitude: 42.854889432370335,
            longitude: 74.66227974277265,
          ),
          Coordinate(
            latitude: 42.85514202597393,
            longitude: 74.66371740680455,
          ),
          Coordinate(
            latitude: 42.8560418822048,
            longitude: 74.66457571368929,
          ),
          Coordinate(
            latitude: 42.85578929228361,
            longitude: 74.67380251270053,
          ),
          Coordinate(
            latitude: 42.855047303345444,
            longitude: 74.69062532764201,
          ),
          Coordinate(
            latitude: 42.85490521932691,
            longitude: 74.69360794406677,
          ),
          Coordinate(
            latitude: 42.85191072278837,
            longitude: 74.70258555692236,
          ),
          Coordinate(
            latitude: 42.85841900940334,
            longitude: 74.70137655245699,
          ),
          Coordinate(
            latitude: 42.858718946898726,
            longitude: 74.70096885668687,
          ),
          Coordinate(
            latitude: 42.8619234508648,
            longitude: 74.70060407626062,
          ),
          Coordinate(
            latitude: 42.86247593462621,
            longitude: 74.70094739901472,
          ),
          Coordinate(
            latitude: 42.86408600175733,
            longitude: 74.7010332297034,
          ),
          Coordinate(
            latitude: 42.863391468132264,
            longitude: 74.70644056307711,
          ),
          Coordinate(
            latitude: 42.866374749834264,
            longitude: 74.70665513979857,
          ),
          Coordinate(
            latitude: 42.86636685769666,
            longitude: 74.70867216097761,
          ),
          Coordinate(
            latitude: 42.865672349817594,
            longitude: 74.71723377215325,
          ),
          Coordinate(
            latitude: 42.866461562537246,
            longitude: 74.71731960284197,
          ),
          Coordinate(
            latitude: 42.86815044358771,
            longitude: 74.71182643877928,
          ),
          Coordinate(
            latitude: 42.87067578640256,
            longitude: 74.7023421477025,
          ),
          Coordinate(
            latitude: 42.8708336168732,
            longitude: 74.69905912386841,
          ),
          Coordinate(
            latitude: 42.86666675615488,
            longitude: 74.69987451540884,
          ),
        ],
        deliveryPrice: 230,
      ),
      DeliveryPolygon(
        id: 5,
        coordinates: [
          Coordinate(
            latitude: 42.86398263381069,
            longitude: 74.70117232568869,
          ),
          Coordinate(
            latitude: 42.86405298273685,
            longitude: 74.70101366048614,
          ),
          Coordinate(
            latitude: 42.86207985434609,
            longitude: 74.70062742238798,
          ),
          Coordinate(
            latitude: 42.85889114461087,
            longitude: 74.70090637212556,
          ),
          Coordinate(
            latitude: 42.85827548350393,
            longitude: 74.70150718694492,
          ),
          Coordinate(
            latitude: 42.85192907817949,
            longitude: 74.70258007055087,
          ),
          Coordinate(
            latitude: 42.854928704853116,
            longitude: 74.69371805196566,
          ),
          Coordinate(
            latitude: 42.85516551121048,
            longitude: 74.68835363393596,
          ),
          Coordinate(
            latitude: 42.855591760368824,
            longitude: 74.67895517354776,
          ),
          Coordinate(
            latitude: 42.85587592481977,
            longitude: 74.67120895391281,
          ),
          Coordinate(
            latitude: 42.85598643287134,
            longitude: 74.66685304647262,
          ),
          Coordinate(
            latitude: 42.8560337934039,
            longitude: 74.66462144857222,
          ),
          Coordinate(
            latitude: 42.85511814995746,
            longitude: 74.66367731099896,
          ),
          Coordinate(
            latitude: 42.854865556255426,
            longitude: 74.66223964696697,
          ),
          Coordinate(
            latitude: 42.85263952903925,
            longitude: 74.67607984548413,
          ),
          Coordinate(
            latitude: 42.85219747148334,
            longitude: 74.6824098587593,
          ),
          Coordinate(
            latitude: 42.85065024502772,
            longitude: 74.68738803869095,
          ),
          Coordinate(
            latitude: 42.850902856070334,
            longitude: 74.68949089055867,
          ),
          Coordinate(
            latitude: 42.84981346340894,
            longitude: 74.69253787999955,
          ),
          Coordinate(
            latitude: 42.84780829876307,
            longitude: 74.69931850438924,
          ),
          Coordinate(
            latitude: 42.84620495601825,
            longitude: 74.70336066876575,
          ),
          Coordinate(
            latitude: 42.84489442441432,
            longitude: 74.70715867673084,
          ),
          Coordinate(
            latitude: 42.84413651383928,
            longitude: 74.70821010266467,
          ),
          Coordinate(
            latitude: 42.84470494764857,
            longitude: 74.7088967481725,
          ),
          Coordinate(
            latitude: 42.85072054914636,
            longitude: 74.71123563443355,
          ),
          Coordinate(
            latitude: 42.85002586414142,
            longitude: 74.71376763974358,
          ),
          Coordinate(
            latitude: 42.85419385612512,
            longitude: 74.7154842535131,
          ),
          Coordinate(
            latitude: 42.85823527475744,
            longitude: 74.71522676144768,
          ),
          Coordinate(
            latitude: 42.858519426980756,
            longitude: 74.71329557095696,
          ),
          Coordinate(
            latitude: 42.85892986668141,
            longitude: 74.71325265561275,
          ),
          Coordinate(
            latitude: 42.86564001460009,
            longitude: 74.7134031987965,
          ),
          Coordinate(
            latitude: 42.86560844581353,
            longitude: 74.71728703745006,
          ),
          Coordinate(
            latitude: 42.86628717007187,
            longitude: 74.70688006647228,
          ),
          Coordinate(
            latitude: 42.86598726950762,
            longitude: 74.70679423578392,
          ),
          Coordinate(
            latitude: 42.86336702386329,
            longitude: 74.70677277811181,
          ),
          Coordinate(
            latitude: 42.863351238911534,
            longitude: 74.70615050562034,
          ),
          Coordinate(
            latitude: 42.86398263381069,
            longitude: 74.70117232568869,
          ),
        ],
        deliveryPrice: 250,
      ),
      DeliveryPolygon(
        id: 6,
        coordinates: [
          Coordinate(
            latitude: 42.87060767155539,
            longitude: 74.70562705999154,
          ),
          Coordinate(
            latitude: 42.86667755738769,
            longitude: 74.71893081670541,
          ),
          Coordinate(
            latitude: 42.864420390008235,
            longitude: 74.72322235112911,
          ),
          Coordinate(
            latitude: 42.86085294886724,
            longitude: 74.7310758591247,
          ),
          Coordinate(
            latitude: 42.86407312609878,
            longitude: 74.73141918187864,
          ),
          Coordinate(
            latitude: 42.86416783463285,
            longitude: 74.74171886449578,
          ),
          Coordinate(
            latitude: 42.8747900464994,
            longitude: 74.73811397557975,
          ),
          Coordinate(
            latitude: 42.87789902312852,
            longitude: 74.73678359990835,
          ),
          Coordinate(
            latitude: 42.87886166918227,
            longitude: 74.73163375859974,
          ),
          Coordinate(
            latitude: 42.87559492360395,
            longitude: 74.72976694112539,
          ),
          Coordinate(
            latitude: 42.87665229510312,
            longitude: 74.72710618978262,
          ),
          Coordinate(
            latitude: 42.877599179464895,
            longitude: 74.72794303899529,
          ),
          Coordinate(
            latitude: 42.87889323109186,
            longitude: 74.72268590932607,
          ),
          Coordinate(
            latitude: 42.880124132956944,
            longitude: 74.72335109716175,
          ),
          Coordinate(
            latitude: 42.88028193909014,
            longitude: 74.72493896489858,
          ),
          Coordinate(
            latitude: 42.88653073517069,
            longitude: 74.73086128240344,
          ),
          Coordinate(
            latitude: 42.88791926994876,
            longitude: 74.73159084325549,
          ),
          Coordinate(
            latitude: 42.89006512541101,
            longitude: 74.7257543564391,
          ),
          Coordinate(
            latitude: 42.88997045690256,
            longitude: 74.71880207067247,
          ),
          Coordinate(
            latitude: 42.88782459812302,
            longitude: 74.71674213414906,
          ),
          Coordinate(
            latitude: 42.88706721824865,
            longitude: 74.7148967743468,
          ),
          Coordinate(
            latitude: 42.88642817171901,
            longitude: 74.71473584180596,
          ),
          Coordinate(
            latitude: 42.88321705911673,
            longitude: 74.71283683782339,
          ),
          Coordinate(
            latitude: 42.87755972644045,
            longitude: 74.709907865579,
          ),
          Coordinate(
            latitude: 42.87060767155539,
            longitude: 74.70562705999154,
          ),
        ],
        deliveryPrice: 230,
      ),
      DeliveryPolygon(
        id: 7,
        coordinates: [
          Coordinate(
            latitude: 42.878001601259385,
            longitude: 74.73724493985871,
          ),
          Coordinate(
            latitude: 42.86423616395654,
            longitude: 74.74151584452046,
          ),
          Coordinate(
            latitude: 42.86751929900543,
            longitude: 74.76220104044333,
          ),
          Coordinate(
            latitude: 42.869602735796875,
            longitude: 74.76683589762104,
          ),
          Coordinate(
            latitude: 42.86726675639947,
            longitude: 74.77275821512595,
          ),
          Coordinate(
            latitude: 42.868655727854076,
            longitude: 74.77593395059955,
          ),
          Coordinate(
            latitude: 42.87193862615236,
            longitude: 74.78262874430072,
          ),
          Coordinate(
            latitude: 42.87149670777934,
            longitude: 74.78855106180563,
          ),
          Coordinate(
            latitude: 42.87440068440966,
            longitude: 74.79370090311423,
          ),
          Coordinate(
            latitude: 42.87589996632225,
            longitude: 74.79531022852316,
          ),
          Coordinate(
            latitude: 42.878724829369226,
            longitude: 74.80247709101101,
          ),
          Coordinate(
            latitude: 42.8870908870327,
            longitude: 74.799815511758,
          ),
          Coordinate(
            latitude: 42.886743751569355,
            longitude: 74.79736933713639,
          ),
          Coordinate(
            latitude: 42.89236079243166,
            longitude: 74.79612479215349,
          ),
          Coordinate(
            latitude: 42.892534344477255,
            longitude: 74.78792796140398,
          ),
          Coordinate(
            latitude: 42.890057236870554,
            longitude: 74.78829274183002,
          ),
          Coordinate(
            latitude: 42.88923677144644,
            longitude: 74.78719840055197,
          ),
          Coordinate(
            latitude: 42.884471543598835,
            longitude: 74.78809962278108,
          ),
          Coordinate(
            latitude: 42.877275662709124,
            longitude: 74.78835711484649,
          ),
          Coordinate(
            latitude: 42.87560281490075,
            longitude: 74.77634081845979,
          ),
          Coordinate(
            latitude: 42.88396659705484,
            longitude: 74.7749246120999,
          ),
          Coordinate(
            latitude: 42.883272288793925,
            longitude: 74.76865897184109,
          ),
          Coordinate(
            latitude: 42.8873749052749,
            longitude: 74.76694235807157,
          ),
          Coordinate(
            latitude: 42.88604947461588,
            longitude: 74.7594750881741,
          ),
          Coordinate(
            latitude: 42.88216769124954,
            longitude: 74.76162085538603,
          ),
          Coordinate(
            latitude: 42.88153648368445,
            longitude: 74.75857386594515,
          ),
          Coordinate(
            latitude: 42.87948501425819,
            longitude: 74.75076327329379,
          ),
          Coordinate(
            latitude: 42.878001601259385,
            longitude: 74.73724493985871,
          ),
        ],
        deliveryPrice: 270,
      ),
      DeliveryPolygon(
        id: 8,
        coordinates: [
          Coordinate(
            latitude: 42.9095308222485,
            longitude: 74.68731376474734,
          ),
          Coordinate(
            latitude: 42.90934154550349,
            longitude: 74.69001743143433,
          ),
          Coordinate(
            latitude: 42.91520885927726,
            longitude: 74.69113323038454,
          ),
          Coordinate(
            latitude: 42.914609535820276,
            longitude: 74.69911548441286,
          ),
          Coordinate(
            latitude: 42.91473570966751,
            longitude: 74.7018620664441,
          ),
          Coordinate(
            latitude: 42.918615428455354,
            longitude: 74.7033641034924,
          ),
          Coordinate(
            latitude: 42.921769490025525,
            longitude: 74.70791312998169,
          ),
          Coordinate(
            latitude: 42.93059999731518,
            longitude: 74.69194862192505,
          ),
          Coordinate(
            latitude: 42.937095913630706,
            longitude: 74.67855903452272,
          ),
          Coordinate(
            latitude: 42.94239304321265,
            longitude: 74.64328262155884,
          ),
          Coordinate(
            latitude: 42.932807424904645,
            longitude: 74.63641616648069,
          ),
          Coordinate(
            latitude: 42.923283381778454,
            longitude: 74.6316954786145,
          ),
          Coordinate(
            latitude: 42.91924625370986,
            longitude: 74.62963554209104,
          ),
          Coordinate(
            latitude: 42.91236990658633,
            longitude: 74.63062259500856,
          ),
          Coordinate(
            latitude: 42.91486188308141,
            longitude: 74.63495704477658,
          ),
          Coordinate(
            latitude: 42.91483033970904,
            longitude: 74.64023563211792,
          ),
          Coordinate(
            latitude: 42.915492747113696,
            longitude: 74.6475312406384,
          ),
          Coordinate(
            latitude: 42.914357187147424,
            longitude: 74.66302367990845,
          ),
          Coordinate(
            latitude: 42.916754455614445,
            longitude: 74.66993305033083,
          ),
          Coordinate(
            latitude: 42.91454644857651,
            longitude: 74.67967483347293,
          ),
          Coordinate(
            latitude: 42.9095308222485,
            longitude: 74.68731376474734,
          ),
        ],
        deliveryPrice: 320,
      ),
      DeliveryPolygon(
        id: 9,
        coordinates: [
          Coordinate(
            latitude: 42.90356831733949,
            longitude: 74.61204025095306,
          ),
          Coordinate(
            latitude: 42.903189725937345,
            longitude: 74.597620695289,
          ),
          Coordinate(
            latitude: 42.8964377860308,
            longitude: 74.59744903391204,
          ),
          Coordinate(
            latitude: 42.891894005495516,
            longitude: 74.59732028787931,
          ),
          Coordinate(
            latitude: 42.88891196623738,
            longitude: 74.59695550745326,
          ),
          Coordinate(
            latitude: 42.883483966566025,
            longitude: 74.59656926935516,
          ),
          Coordinate(
            latitude: 42.876051244924646,
            longitude: 74.59603282755216,
          ),
          Coordinate(
            latitude: 42.86988029625542,
            longitude: 74.59556075876549,
          ),
          Coordinate(
            latitude: 42.869754029947174,
            longitude: 74.59886524027183,
          ),
          Coordinate(
            latitude: 42.86299283656113,
            longitude: 74.59830607726535,
          ),
          Coordinate(
            latitude: 42.86024617703202,
            longitude: 74.59804858519988,
          ),
          Coordinate(
            latitude: 42.8602935342739,
            longitude: 74.59753360106905,
          ),
          Coordinate(
            latitude: 42.85716787783449,
            longitude: 74.5973833973642,
          ),
          Coordinate(
            latitude: 42.85320532674737,
            longitude: 74.59706153228237,
          ),
          Coordinate(
            latitude: 42.85260539629016,
            longitude: 74.59961499526456,
          ),
          Coordinate(
            latitude: 42.852573821163844,
            longitude: 74.60229720427913,
          ),
          Coordinate(
            latitude: 42.843037291388775,
            longitude: 74.60182513549255,
          ),
          Coordinate(
            latitude: 42.84289517959144,
            longitude: 74.60886325194761,
          ),
          Coordinate(
            latitude: 42.842074082640956,
            longitude: 74.62542857482356,
          ),
          Coordinate(
            latitude: 42.841568786756284,
            longitude: 74.65023364379329,
          ),
          Coordinate(
            latitude: 42.85543133359689,
            longitude: 74.64976157500666,
          ),
          Coordinate(
            latitude: 42.85539186612603,
            longitude: 74.64835609748283,
          ),
          Coordinate(
            latitude: 42.85592072848312,
            longitude: 74.64535202338607,
          ),
          Coordinate(
            latitude: 42.85617135441995,
            longitude: 74.63818124060174,
          ),
          Coordinate(
            latitude: 42.856202928042,
            longitude: 74.63013461355699,
          ),
          Coordinate(
            latitude: 42.8563450090531,
            longitude: 74.62363293890488,
          ),
          Coordinate(
            latitude: 42.85666863676185,
            longitude: 74.61627295736798,
          ),
          Coordinate(
            latitude: 42.85696068957159,
            longitude: 74.60878422979835,
          ),
          Coordinate(
            latitude: 42.86277887834191,
            longitude: 74.60946503054227,
          ),
          Coordinate(
            latitude: 42.862782824617064,
            longitude: 74.61064520250883,
          ),
          Coordinate(
            latitude: 42.86437709902438,
            longitude: 74.61076321970548,
          ),
          Coordinate(
            latitude: 42.87056438504125,
            longitude: 74.61132111918057,
          ),
          Coordinate(
            latitude: 42.87892010599868,
            longitude: 74.6118044376145,
          ),
          Coordinate(
            latitude: 42.89234821723528,
            longitude: 74.61154694554892,
          ),
          Coordinate(
            latitude: 42.89589804829746,
            longitude: 74.61146111486046,
          ),
          Coordinate(
            latitude: 42.90291821927204,
            longitude: 74.61199755666345,
          ),
          Coordinate(
            latitude: 42.90356831733949,
            longitude: 74.61204025095306,
          ),
        ],
        deliveryPrice: 280,
      ),
      DeliveryPolygon(
        id: 10,
        coordinates: [
          Coordinate(
            latitude: 42.84320870799879,
            longitude: 74.60152621266906,
          ),
          Coordinate(
            latitude: 42.843224498136806,
            longitude: 74.59927315709655,
          ),
          Coordinate(
            latitude: 42.84036641693879,
            longitude: 74.60034604070253,
          ),
          Coordinate(
            latitude: 42.83357596632878,
            longitude: 74.60011000630922,
          ),
          Coordinate(
            latitude: 42.828711646718276,
            longitude: 74.59983105657165,
          ),
          Coordinate(
            latitude: 42.828285210729995,
            longitude: 74.60742707250175,
          ),
          Coordinate(
            latitude: 42.82803250653403,
            longitude: 74.6090578555828,
          ),
          Coordinate(
            latitude: 42.825394844117106,
            longitude: 74.61354250905566,
          ),
          Coordinate(
            latitude: 42.820877386540715,
            longitude: 74.61910004613442,
          ),
          Coordinate(
            latitude: 42.813989993219856,
            longitude: 74.63019366261999,
          ),
          Coordinate(
            latitude: 42.81124113890656,
            longitude: 74.6340775012736,
          ),
          Coordinate(
            latitude: 42.81073558907964,
            longitude: 74.63572974202674,
          ),
          Coordinate(
            latitude: 42.81271036946561,
            longitude: 74.64542860982462,
          ),
          Coordinate(
            latitude: 42.812094244901324,
            longitude: 74.64660878179099,
          ),
          Coordinate(
            latitude: 42.81203105227852,
            longitude: 74.64954848287134,
          ),
          Coordinate(
            latitude: 42.81222062995182,
            longitude: 74.65227360723043,
          ),
          Coordinate(
            latitude: 42.81312111590693,
            longitude: 74.65650076863793,
          ),
          Coordinate(
            latitude: 42.815474955410075,
            longitude: 74.65557808873677,
          ),
          Coordinate(
            latitude: 42.81596466906709,
            longitude: 74.64903349874045,
          ),
          Coordinate(
            latitude: 42.818618533199434,
            longitude: 74.64939827916649,
          ),
          Coordinate(
            latitude: 42.82082999903421,
            longitude: 74.6498059749367,
          ),
          Coordinate(
            latitude: 42.82548961261931,
            longitude: 74.64972014424823,
          ),
          Coordinate(
            latitude: 42.827313873518094,
            longitude: 74.64890475270761,
          ),
          Coordinate(
            latitude: 42.83417608338757,
            longitude: 74.64972014424802,
          ),
          Coordinate(
            latitude: 42.84147176849938,
            longitude: 74.64924807546134,
          ),
          Coordinate(
            latitude: 42.84169283642122,
            longitude: 74.63650221822253,
          ),
          Coordinate(
            latitude: 42.84221392173198,
            longitude: 74.6229409694432,
          ),
          Coordinate(
            latitude: 42.843098177591834,
            longitude: 74.60412259099475,
          ),
          Coordinate(
            latitude: 42.84320870799879,
            longitude: 74.60152621266906,
          ),
        ],
        deliveryPrice: 320,
      ),
      DeliveryPolygon(
        id: 11,
        coordinates: [
          Coordinate(
            latitude: 42.82883532016571,
            longitude: 74.59929441978686,
          ),
          Coordinate(
            latitude: 42.82959341978933,
            longitude: 74.56264471580735,
          ),
          Coordinate(
            latitude: 42.81714676586162,
            longitude: 74.56367468406908,
          ),
          Coordinate(
            latitude: 42.804887188360155,
            longitude: 74.56951117088548,
          ),
          Coordinate(
            latitude: 42.80362317521784,
            longitude: 74.58298658897628,
          ),
          Coordinate(
            latitude: 42.8031175626773,
            longitude: 74.58496069481122,
          ),
          Coordinate(
            latitude: 42.805898380144676,
            longitude: 74.61328482200851,
          ),
          Coordinate(
            latitude: 42.811143670339725,
            longitude: 74.63439917137373,
          ),
          Coordinate(
            latitude: 42.823275636793944,
            longitude: 74.61577391197433,
          ),
          Coordinate(
            latitude: 42.82801403503008,
            longitude: 74.6081349806999,
          ),
          Coordinate(
            latitude: 42.82883532016571,
            longitude: 74.59929441978686,
          ),
        ],
        deliveryPrice: 400,
      ),
      DeliveryPolygon(
        id: 12,
        coordinates: [
          Coordinate(
            latitude: 42.85450551308609,
            longitude: 74.66389293668287,
          ),
          Coordinate(
            latitude: 42.85013229398216,
            longitude: 74.66249818799515,
          ),
          Coordinate(
            latitude: 42.845253497449626,
            longitude: 74.66179008481515,
          ),
          Coordinate(
            latitude: 42.84237972044283,
            longitude: 74.66157550809395,
          ),
          Coordinate(
            latitude: 42.843169233034594,
            longitude: 74.66520185468208,
          ),
          Coordinate(
            latitude: 42.84369030577832,
            longitude: 74.67530841825022,
          ),
          Coordinate(
            latitude: 42.84940602525705,
            longitude: 74.67571611402049,
          ),
          Coordinate(
            latitude: 42.85256886980763,
            longitude: 74.67594122459657,
          ),
          Coordinate(
            latitude: 42.85450551308609,
            longitude: 74.66389293668287,
          ),
        ],
        deliveryPrice: 280,
      ),
      DeliveryPolygon(
        id: 13,
        coordinates: [
          Coordinate(
            latitude: 42.90324231561184,
            longitude: 74.59719156791898,
          ),
          Coordinate(
            latitude: 42.903305414287274,
            longitude: 74.59298586418365,
          ),
          Coordinate(
            latitude: 42.905545375123,
            longitude: 74.59049677421781,
          ),
          Coordinate(
            latitude: 42.905545375123,
            longitude: 74.58367323448391,
          ),
          Coordinate(
            latitude: 42.90557692328174,
            longitude: 74.57345938255519,
          ),
          Coordinate(
            latitude: 42.897626273138584,
            longitude: 74.57433914711203,
          ),
          Coordinate(
            latitude: 42.884436012647946,
            longitude: 74.57631325294696,
          ),
          Coordinate(
            latitude: 42.86682353366574,
            longitude: 74.57468246986592,
          ),
          Coordinate(
            latitude: 42.86556079591895,
            longitude: 74.56893181373796,
          ),
          Coordinate(
            latitude: 42.852016297592215,
            longitude: 74.56757998039438,
          ),
          Coordinate(
            latitude: 42.85163738748098,
            longitude: 74.56805204918102,
          ),
          Coordinate(
            latitude: 42.848132357954896,
            longitude: 74.56766581108286,
          ),
          Coordinate(
            latitude: 42.84683765676899,
            longitude: 74.56742977668955,
          ),
          Coordinate(
            latitude: 42.84619029591395,
            longitude: 74.56828808357433,
          ),
          Coordinate(
            latitude: 42.83979526671469,
            longitude: 74.56867432167249,
          ),
          Coordinate(
            latitude: 42.82946707121119,
            longitude: 74.56925367881969,
          ),
          Coordinate(
            latitude: 42.82921437185694,
            longitude: 74.5858404593678,
          ),
          Coordinate(
            latitude: 42.82899399446015,
            longitude: 74.59713779243407,
          ),
          Coordinate(
            latitude: 42.82894661307013,
            longitude: 74.59964834007195,
          ),
          Coordinate(
            latitude: 42.835863912418745,
            longitude: 74.59992728980953,
          ),
          Coordinate(
            latitude: 42.8413987695468,
            longitude: 74.59974489959653,
          ),
          Coordinate(
            latitude: 42.84240936000455,
            longitude: 74.59919772895748,
          ),
          Coordinate(
            latitude: 42.84321466238028,
            longitude: 74.59918700012138,
          ),
          Coordinate(
            latitude: 42.84333308830483,
            longitude: 74.60022769721915,
          ),
          Coordinate(
            latitude: 42.84329361302205,
            longitude: 74.60177264961173,
          ),
          Coordinate(
            latitude: 42.84802257113569,
            longitude: 74.60191212448046,
          ),
          Coordinate(
            latitude: 42.85211176011788,
            longitude: 74.60212670120163,
          ),
          Coordinate(
            latitude: 42.85258539377673,
            longitude: 74.60200868400494,
          ),
          Coordinate(
            latitude: 42.85258539377673,
            longitude: 74.59957323821938,
          ),
          Coordinate(
            latitude: 42.85319321823977,
            longitude: 74.59698758872902,
          ),
          Coordinate(
            latitude: 42.85505612313984,
            longitude: 74.59719143661418,
          ),
          Coordinate(
            latitude: 42.86029721295819,
            longitude: 74.5974596575156,
          ),
          Coordinate(
            latitude: 42.86032089158888,
            longitude: 74.59796391281039,
          ),
          Coordinate(
            latitude: 42.86310701034946,
            longitude: 74.59825359138397,
          ),
          Coordinate(
            latitude: 42.86737670866426,
            longitude: 74.59858618530185,
          ),
          Coordinate(
            latitude: 42.869625875673655,
            longitude: 74.5987149313345,
          ),
          Coordinate(
            latitude: 42.86976792554922,
            longitude: 74.59598980697535,
          ),
          Coordinate(
            latitude: 42.86986262530817,
            longitude: 74.59539972099205,
          ),
          Coordinate(
            latitude: 42.87279824450399,
            longitude: 74.59570012840173,
          ),
          Coordinate(
            latitude: 42.87640557959394,
            longitude: 74.59597693176488,
          ),
          Coordinate(
            latitude: 42.88135290879797,
            longitude: 74.59634171219088,
          ),
          Coordinate(
            latitude: 42.89263479647567,
            longitude: 74.5970390865347,
          ),
          Coordinate(
            latitude: 42.90324231561184,
            longitude: 74.59719156791898,
          ),
        ],
        deliveryPrice: 320,
      ),
      DeliveryPolygon(
        id: 14,
        coordinates: [
          Coordinate(
            latitude: 42.90602685065632,
            longitude: 74.5737060801318,
          ),
          Coordinate(
            latitude: 42.90566911640815,
            longitude: 74.57372341532445,
          ),
          Coordinate(
            latitude: 42.90559813311029,
            longitude: 74.57591209788059,
          ),
          Coordinate(
            latitude: 42.90559813308555,
            longitude: 74.58083663363198,
          ),
          Coordinate(
            latitude: 42.90562968119235,
            longitude: 74.585342744777,
          ),
          Coordinate(
            latitude: 42.90555081080824,
            longitude: 74.59072862047896,
          ),
          Coordinate(
            latitude: 42.903334512131096,
            longitude: 74.59331426996931,
          ),
          Coordinate(
            latitude: 42.903326624729615,
            longitude: 74.59989104647386,
          ),
          Coordinate(
            latitude: 42.90347084039342,
            longitude: 74.60677759751162,
          ),
          Coordinate(
            latitude: 42.903636473634535,
            longitude: 74.61223857506594,
          ),
          Coordinate(
            latitude: 42.905119265761776,
            longitude: 74.61241023644294,
          ),
          Coordinate(
            latitude: 42.9049930720856,
            longitude: 74.61597221001472,
          ),
          Coordinate(
            latitude: 42.90490631378233,
            longitude: 74.61821453675117,
          ),
          Coordinate(
            latitude: 42.90394465265386,
            longitude: 74.62048380535144,
          ),
          Coordinate(
            latitude: 42.904796469509584,
            longitude: 74.62069838207266,
          ),
          Coordinate(
            latitude: 42.90429169058166,
            longitude: 74.6225437418749,
          ),
          Coordinate(
            latitude: 42.905048857412424,
            longitude: 74.6243461863329,
          ),
          Coordinate(
            latitude: 42.90713101789998,
            longitude: 74.62417452495595,
          ),
          Coordinate(
            latitude: 42.90987557576751,
            longitude: 74.6271356837084,
          ),
          Coordinate(
            latitude: 42.91211529614828,
            longitude: 74.6271356837084,
          ),
          Coordinate(
            latitude: 42.91239919851131,
            longitude: 74.63035433452627,
          ),
          Coordinate(
            latitude: 42.91902321303858,
            longitude: 74.62953894298576,
          ),
          Coordinate(
            latitude: 42.918360843857805,
            longitude: 74.62159960430165,
          ),
          Coordinate(
            latitude: 42.918928589308976,
            longitude: 74.6180805460741,
          ),
          Coordinate(
            latitude: 42.917256879261636,
            longitude: 74.61181490581535,
          ),
          Coordinate(
            latitude: 42.91858163435686,
            longitude: 74.60945456188226,
          ),
          Coordinate(
            latitude: 42.91896013054374,
            longitude: 74.60314600627925,
          ),
          Coordinate(
            latitude: 42.919401706468705,
            longitude: 74.60198729198483,
          ),
          Coordinate(
            latitude: 42.91927554224395,
            longitude: 74.59902613323237,
          ),
          Coordinate(
            latitude: 42.91965403411288,
            longitude: 74.59718077343013,
          ),
          Coordinate(
            latitude: 42.91952787040851,
            longitude: 74.5871814982226,
          ),
          Coordinate(
            latitude: 42.92009560502914,
            longitude: 74.58027212780023,
          ),
          Coordinate(
            latitude: 42.92097873729949,
            longitude: 74.57877009075187,
          ),
          Coordinate(
            latitude: 42.921104898011635,
            longitude: 74.57739679973625,
          ),
          Coordinate(
            latitude: 42.92060025360194,
            longitude: 74.57417814891838,
          ),
          Coordinate(
            latitude: 42.92135721865532,
            longitude: 74.57228987377192,
          ),
          Coordinate(
            latitude: 42.91826621905423,
            longitude: 74.57271902721428,
          ),
          Coordinate(
            latitude: 42.91407104121468,
            longitude: 74.57323401134518,
          ),
          Coordinate(
            latitude: 42.90602685065632,
            longitude: 74.5737060801318,
          ),
        ],
        deliveryPrice: 320,
      ),
      DeliveryPolygon(
        id: 15,
        coordinates: [
          Coordinate(
            latitude: 42.88492413406275,
            longitude: 74.5746609465407,
          ),
          Coordinate(
            latitude: 42.88404048145197,
            longitude: 74.55594985645277,
          ),
          Coordinate(
            latitude: 42.88492413406275,
            longitude: 74.51990096729264,
          ),
          Coordinate(
            latitude: 42.874698231257305,
            longitude: 74.52161758106216,
          ),
          Coordinate(
            latitude: 42.874161639867545,
            longitude: 74.5232483641432,
          ),
          Coordinate(
            latitude: 42.86352353425941,
            longitude: 74.52539413135513,
          ),
          Coordinate(
            latitude: 42.86245015109575,
            longitude: 74.50994460742933,
          ),
          Coordinate(
            latitude: 42.85225207285223,
            longitude: 74.51136081378917,
          ),
          Coordinate(
            latitude: 42.84581030732376,
            longitude: 74.51251952808359,
          ),
          Coordinate(
            latitude: 42.83583055029013,
            longitude: 74.51153247516606,
          ),
          Coordinate(
            latitude: 42.825501687337194,
            longitude: 74.5111462370679,
          ),
          Coordinate(
            latitude: 42.8243012786277,
            longitude: 74.53989951770747,
          ),
          Coordinate(
            latitude: 42.82986086911803,
            longitude: 74.5580956236645,
          ),
          Coordinate(
            latitude: 42.82976610761514,
            longitude: 74.5689532057568,
          ),
          Coordinate(
            latitude: 42.83633589356584,
            longitude: 74.56865279834712,
          ),
          Coordinate(
            latitude: 42.84618925356495,
            longitude: 74.56809489887202,
          ),
          Coordinate(
            latitude: 42.846915560460424,
            longitude: 74.5673224226757,
          ),
          Coordinate(
            latitude: 42.85176264893197,
            longitude: 74.56785886447865,
          ),
          Coordinate(
            latitude: 42.85212577045174,
            longitude: 74.56742971103628,
          ),
          Coordinate(
            latitude: 42.85687772745219,
            longitude: 74.56803052585565,
          ),
          Coordinate(
            latitude: 42.86219758785107,
            longitude: 74.56845967929796,
          ),
          Coordinate(
            latitude: 42.86560710723495,
            longitude: 74.56891029041243,
          ),
          Coordinate(
            latitude: 42.866901412139555,
            longitude: 74.57455365817977,
          ),
          Coordinate(
            latitude: 42.878832984337286,
            longitude: 74.57556216876934,
          ),
          Coordinate(
            latitude: 42.88480596333407,
            longitude: 74.57613311187018,
          ),
          Coordinate(
            latitude: 42.88492413406275,
            longitude: 74.5746609465407,
          ),
        ],
        deliveryPrice: 450,
      ),
      DeliveryPolygon(
        id: 16,
        coordinates: [
          Coordinate(
            latitude: 42.89555852481646,
            longitude: 74.5742168572387,
          ),
          Coordinate(
            latitude: 42.895085223274535,
            longitude: 74.56958200006093,
          ),
          Coordinate(
            latitude: 42.89584250398538,
            longitude: 74.56129933862293,
          ),
          Coordinate(
            latitude: 42.895463864800774,
            longitude: 74.55614949731434,
          ),
          Coordinate(
            latitude: 42.89625269379288,
            longitude: 74.55031301049796,
          ),
          Coordinate(
            latitude: 42.89543231142968,
            longitude: 74.54739476708976,
          ),
          Coordinate(
            latitude: 42.89559007812248,
            longitude: 74.54074288873281,
          ),
          Coordinate(
            latitude: 42.89334975303424,
            longitude: 74.51598073510728,
          ),
          Coordinate(
            latitude: 42.89155112282799,
            longitude: 74.51709653405749,
          ),
          Coordinate(
            latitude: 42.88896352705203,
            longitude: 74.52108766107162,
          ),
          Coordinate(
            latitude: 42.88741722863053,
            longitude: 74.52220346002187,
          ),
          Coordinate(
            latitude: 42.88495569342018,
            longitude: 74.52306176690665,
          ),
          Coordinate(
            latitude: 42.88479789932741,
            longitude: 74.54597856072988,
          ),
          Coordinate(
            latitude: 42.8847347816013,
            longitude: 74.55460454492172,
          ),
          Coordinate(
            latitude: 42.88394580422662,
            longitude: 74.55572034387193,
          ),
          Coordinate(
            latitude: 42.884166718915964,
            longitude: 74.56181432275378,
          ),
          Coordinate(
            latitude: 42.88498725221477,
            longitude: 74.57155610589587,
          ),
          Coordinate(
            latitude: 42.884892575856675,
            longitude: 74.57614804772936,
          ),
          Coordinate(
            latitude: 42.89025733865708,
            longitude: 74.57528974084458,
          ),
          Coordinate(
            latitude: 42.89555852481646,
            longitude: 74.5742168572387,
          ),
        ],
        deliveryPrice: 400,
      ),
      DeliveryPolygon(
        id: 17,
        coordinates: [
          Coordinate(
            latitude: 42.88405723103115,
            longitude: 74.69880010156206,
          ),
          Coordinate(
            latitude: 42.88001751502005,
            longitude: 74.69830657510332,
          ),
          Coordinate(
            latitude: 42.87323197255511,
            longitude: 74.69738797240228,
          ),
          Coordinate(
            latitude: 42.87211141127021,
            longitude: 74.6988900094506,
          ),
          Coordinate(
            latitude: 42.87064360281193,
            longitude: 74.70506981902092,
          ),
          Coordinate(
            latitude: 42.87064360281193,
            longitude: 74.70558480315177,
          ),
          Coordinate(
            latitude: 42.87274271592293,
            longitude: 74.7066147714135,
          ),
          Coordinate(
            latitude: 42.87749307480968,
            longitude: 74.70949009947748,
          ),
          Coordinate(
            latitude: 42.88710313962907,
            longitude: 74.71483305983513,
          ),
          Coordinate(
            latitude: 42.88967503591674,
            longitude: 74.71376017622913,
          ),
          Coordinate(
            latitude: 42.88894923565508,
            longitude: 74.7075374513146,
          ),
          Coordinate(
            latitude: 42.88958036680521,
            longitude: 74.70221594862905,
          ),
          Coordinate(
            latitude: 42.89327235370878,
            longitude: 74.70324591689078,
          ),
          Coordinate(
            latitude: 42.894534520393464,
            longitude: 74.70307425551378,
          ),
          Coordinate(
            latitude: 42.894439858794605,
            longitude: 74.70200137190784,
          ),
          Coordinate(
            latitude: 42.89150527664008,
            longitude: 74.70011309676138,
          ),
          Coordinate(
            latitude: 42.890590163116215,
            longitude: 74.69955519728627,
          ),
          Coordinate(
            latitude: 42.89567044816429,
            longitude: 74.68208865218128,
          ),
          Coordinate(
            latitude: 42.89721653825995,
            longitude: 74.67638091139759,
          ),
          Coordinate(
            latitude: 42.900403253746624,
            longitude: 74.67582301192249,
          ),
          Coordinate(
            latitude: 42.90213852410153,
            longitude: 74.67543677382433,
          ),
          Coordinate(
            latitude: 42.903621352516886,
            longitude: 74.67814044051136,
          ),
          Coordinate(
            latitude: 42.90677618706949,
            longitude: 74.67917040877309,
          ),
          Coordinate(
            latitude: 42.90873210282605,
            longitude: 74.67861250929799,
          ),
          Coordinate(
            latitude: 42.910782592572,
            longitude: 74.67848376326526,
          ),
          Coordinate(
            latitude: 42.91217057738746,
            longitude: 74.67951373152698,
          ),
          Coordinate(
            latitude: 42.913400810335936,
            longitude: 74.67977122359241,
          ),
          Coordinate(
            latitude: 42.914315582904386,
            longitude: 74.67376307539908,
          ),
          Coordinate(
            latitude: 42.91217057738746,
            longitude: 74.67341975264513,
          ),
          Coordinate(
            latitude: 42.90396839230248,
            longitude: 74.66891364150011,
          ),
          Coordinate(
            latitude: 42.89983533645073,
            longitude: 74.66796950392686,
          ),
          Coordinate(
            latitude: 42.902012324354146,
            longitude: 74.65084628157575,
          ),
          Coordinate(
            latitude: 42.90150752249031,
            longitude: 74.64363650374375,
          ),
          Coordinate(
            latitude: 42.901444421986305,
            longitude: 74.63247851424177,
          ),
          Coordinate(
            latitude: 42.89811577690533,
            longitude: 74.63357285551982,
          ),
          Coordinate(
            latitude: 42.89668014424419,
            longitude: 74.63402346663433,
          ),
          Coordinate(
            latitude: 42.89467651271547,
            longitude: 74.63415221266702,
          ),
          Coordinate(
            latitude: 42.894755397086435,
            longitude: 74.63795022063215,
          ),
          Coordinate(
            latitude: 42.89440830509395,
            longitude: 74.63915185027082,
          ),
          Coordinate(
            latitude: 42.89262548339703,
            longitude: 74.64346484236675,
          ),
          Coordinate(
            latitude: 42.89346168056826,
            longitude: 74.64704827361066,
          ),
          Coordinate(
            latitude: 42.89387188635102,
            longitude: 74.6489794641014,
          ),
          Coordinate(
            latitude: 42.892515041432276,
            longitude: 74.65204791121442,
          ),
          Coordinate(
            latitude: 42.892309934376584,
            longitude: 74.65985850386575,
          ),
          Coordinate(
            latitude: 42.89092149917502,
            longitude: 74.66917113356543,
          ),
          Coordinate(
            latitude: 42.88965925803899,
            longitude: 74.67788294844578,
          ),
          Coordinate(
            latitude: 42.88830231977317,
            longitude: 74.6821744828696,
          ),
          Coordinate(
            latitude: 42.88768695416368,
            longitude: 74.68425587706517,
          ),
          Coordinate(
            latitude: 42.88875989536381,
            longitude: 74.68942717604587,
          ),
          Coordinate(
            latitude: 42.886740225729454,
            longitude: 74.6942980676169,
          ),
          Coordinate(
            latitude: 42.88532010566251,
            longitude: 74.69665841154999,
          ),
          Coordinate(
            latitude: 42.88405723103115,
            longitude: 74.69880010156206,
          ),
        ],
        deliveryPrice: 220,
      ),
      DeliveryPolygon(
        id: 18,
        coordinates: [
          Coordinate(
            latitude: 42.89639616909683,
            longitude: 74.61160019926965,
          ),
          Coordinate(
            latitude: 42.89486901829936,
            longitude: 74.6187422178024,
          ),
          Coordinate(
            latitude: 42.893701521396714,
            longitude: 74.62547992684783,
          ),
          Coordinate(
            latitude: 42.89385929252453,
            longitude: 74.62663864114225,
          ),
          Coordinate(
            latitude: 42.8954369816914,
            longitude: 74.62968563058317,
          ),
          Coordinate(
            latitude: 42.8951687774011,
            longitude: 74.63112329461516,
          ),
          Coordinate(
            latitude: 42.894837464596925,
            longitude: 74.6327326200241,
          ),
          Coordinate(
            latitude: 42.8946008114963,
            longitude: 74.63339780785978,
          ),
          Coordinate(
            latitude: 42.89461658839814,
            longitude: 74.63395570733488,
          ),
          Coordinate(
            latitude: 42.89646245784957,
            longitude: 74.63395570733488,
          ),
          Coordinate(
            latitude: 42.89898663367831,
            longitude: 74.63316177346647,
          ),
          Coordinate(
            latitude: 42.90141605462139,
            longitude: 74.63247512795868,
          ),
          Coordinate(
            latitude: 42.90170000659548,
            longitude: 74.63275407769626,
          ),
          Coordinate(
            latitude: 42.91233148334839,
            longitude: 74.63058685281227,
          ),
          Coordinate(
            latitude: 42.91198130889434,
            longitude: 74.62739304594933,
          ),
          Coordinate(
            latitude: 42.906082137754844,
            longitude: 74.62747887663781,
          ),
          Coordinate(
            latitude: 42.90587707612501,
            longitude: 74.62677077345786,
          ),
          Coordinate(
            latitude: 42.90534075782011,
            longitude: 74.62529019408166,
          ),
          Coordinate(
            latitude: 42.90387374557507,
            longitude: 74.62297276549278,
          ),
          Coordinate(
            latitude: 42.90431543038061,
            longitude: 74.62136344008384,
          ),
          Coordinate(
            latitude: 42.903384733679694,
            longitude: 74.62069825224816,
          ),
          Coordinate(
            latitude: 42.90483598338105,
            longitude: 74.61829499297082,
          ),
          Coordinate(
            latitude: 42.905088371120954,
            longitude: 74.61254433684284,
          ),
          Coordinate(
            latitude: 42.90262754623795,
            longitude: 74.61228684477743,
          ),
          Coordinate(
            latitude: 42.89639616909683,
            longitude: 74.61160019926965,
          ),
        ],
        deliveryPrice: 280,
      ),
      DeliveryPolygon(
        id: 19,
        coordinates: [
          Coordinate(
            latitude: 42.881726,
            longitude: 74.639674,
          ),
        ],
        deliveryPrice: 180,
      ),
      DeliveryPolygon(
        id: 20,
        coordinates: [
          Coordinate(
            latitude: 42.884518,
            longitude: 74.650871,
          ),
        ],
        deliveryPrice: 180,
      ),
      DeliveryPolygon(
        id: 21,
        coordinates: [
          Coordinate(
            latitude: 42.885152,
            longitude: 74.65035,
          ),
        ],
        deliveryPrice: 180,
      ),
    ];
  }
}
