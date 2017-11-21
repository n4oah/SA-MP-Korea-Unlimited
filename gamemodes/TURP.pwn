/*
 * The Unlimited 백지모드
 *
 * 모드 제작자 : 김호진
 * 오브젝트 및 커스텀 : 테슬라
 *
 * MySQL ver R41-2를 사용하여 더욱 빠른 데이터베이스 구축
 * 테이블 및 컬럼을 서버 내에서 자동으로 동적으로 추가해줌
 * 플레이어 데이터 부분은 ORM방식을 채택하여 더욱 간편한 코딩 가능
 *
 * SHA-512 플러그인을 이용하여 비밀번호 암호화
 *
 *
 * 플레이어 기본 정보를 정할 때 텍스트드로우 클릭 형식을 사용
 *
 * 장면에 맞는 동적인 캠 화면과 대사를 통해 서버 소개
 * Spacebar와 LShift키를 이용하여 다음 장면과 전 장면 관람 가능
 *
 * 인벤토리 시스템 구축, txd를 사용하여 아이템 체계화
 * 인벤토리 사용/주기/버리기/자리이동 등 기능 사용 가능
 *
 * txd를 사용하여 스마트폰 기능 구축
 *
 * DB설계를 SMS기능 다 만든 뒤에 하는 바람에 SMS 테이블은 컬럼이 최적화가 안 되있음
 */
// AddStaticVehicle(451,1301.8271,-1313.6812,13.7075,218.8194,1,1); // 전시용 차량
//========================= include =========================//
#include <TURP>
//========================= define =========================//
#define HOST_NAME 		"&The Unlimited Role Playing"
#define MAP_NAME		"제작중"
#define MODE_NAME		"TURP 0.07v"
#define LANGUAGE		"Korean"
#define FORUM			"cafe.daum.net/turp"

#define SERVER_NAME		"The Unlimited Role Play"
#define SERVER_VIRSION	"TURP 0.07v"

#define MySQL_HOST 		"localhost"     // MySQL 접속 hostIP
#define MySQL_User 		"root"          // MySQL user
#define MySQL_DB		"turp"          // MySQL DB
#define MySQL_Password 	"ghwls12"       // MySQL 패스워드

#define MySQL_USER      "account"       // 유저 데이터 관리 테이블
#define MySQL_SMS       "sms"           // 유저 sms 관리 테이블
#define MySQL_NOTE      "note"          // 유저 노트 관리 테이블
#define MySQL_NUM_NOTE  "numnote"       // 유저 전화번호부 관리 테이블
#define MySQL_MP3       "mp3"           // 유저 mp3 관리 테이블
#define MySQL_VEHICLE   "vehicle"       // 차량 데이터 관리 테이블
#define MySQL_BUILD   	"build"         // 집, 사업장, 입장, 퇴장 관리 테이블
#define MySQL_ATM       "atm"           // ATM 데이터 관리 테이블
#define MySQL_FACTION   "faction"       // 팩션 데이터 관리 테이블

#pragma dynamic 99999

#define RGBToHex(%0,%1,%2,%3) %0 << 24 | %1 << 16 | %2 << 8 | %3
#define SetPlayerPosEx(%0,%1,%2,%3,%4,%5,%6); SetPlayerPos(%0, %1, %2, %3); SetPlayerFacingAngle(%0, %4); SetPlayerInteriorEx(%0,%5); SetPlayerVirtualWorldEx(%0, %6);

#define MAX_PLAYERS 				100
#define MAX_BUILD 					100
#define MAX_COUNTRY     			29
#define MAX_ACTOR       			10
#define MAX_ACTOR_DIALOGUE          3
#define MAX_MAP                     50
#define MAX_HUD_BAR                 4
#define MAX_CALLCON_SECOND          90
#define MAX_NUM_LENGTH              10
#define MAX_SMS                     20
#define MAX_NOTE                    10
#define MAX_NUM_NOTE                10
#define MAX_MP3                     10
#define MAX_ATM                     30
#define MAX_OWNER_VEHICLES          10
#define MAX_FACTION                 30

#define BANK_CRE_PRICE              25

#define START_YEAR      			1935
#define END_YEAR        			1997

#define FADE_DELAY 					50

#define BAG_INVEN_OBJECT          	19811

#define ITEM_EXCHANGE               3.0
//========================= main =========================//
main() {
	new b[6];
	
	format(b, sizeof(b), "hello");
	print("aspdfijasdpfijaspodijfasipdjf");
	print(b);
}
//========================= enum =========================//
enum pInfo
{
	//============ save ============//
	pName[MAX_PLAYER_NAME],         
	pPassword[128],                 
	ORM:ORM_ID,                     
	pID,                            
	pAge,                           
	pBornYear,                      
	pBornMonth,                     
	pBornDay,                       
	pSex,                           
	pCountry,                       
	pSkin,                          
	pAdmin,                         
	pAdminName[128],                
	Float:pPos[3],                  
	Float:pAngle,                   
	pInterior,                      
	pVirtualWorld,                  
	pTutorial,                      
	pChatBan,                 		
	pMoney,                         
	Float:pHealth,                  
	Float:pArmour,
	Float:pHungry,
	Float:pEnergy,
	pPhoneNumber,
	pPhonePower,
	pAccountNum,
	pAccountMoney,
	pShopMode,//1: 차량구매 모드 2: 차량 튜닝모드
	//============ save ============//
	
	//============ not save ============//
	bool:pLoginCheck,               
	pPasswordCheck,                 
	pTmpPwd[128],                   
	pRegState,                      
	pPlayerActor,                   
	pPlayerActorSkin,               
	pPlayerActorIndex,              
	bool:pRegInfoClick,             
	pContinent[MAX_COUNTRY],        
	bool:pSpectating,               
	pSerLogoTimer,                	
	pSerLogoLevel,                  
	bool:pCh_Whisper,               
	bool:pAdminWork,                
	pStartBgm,                      
	pIntroBgm,                      
	pTutScreen,                     
	bool:pIsSave,                   
	pFirstSpawn,                    
	pDialogProgress[10],            
	Float:pBuildInPos[3],           
    pBuildInInterior,           	
    pBuildInVirtualWorld,           
    Float:pBuildOutPos[3],
	pTempAccountNum,
    pBuildOutInterior, 				
    pBuildOutVirtualWorld,          
    pDialogBuildNum[MAX_BUILD],     
    pDialogBuildIndex,              
    bool:pInventoryMode,            
    pItemClick,                   	
    pItemDisPlace[2],               
    pGive_Item_Index[MAX_PLAYERS],  
    pGive_Item_Player,              
    PlayerBar:pHudBar[MAX_HUD_BAR], 
	bool:pPhoneTDChk,               
	bool:pPhoneSelChk,              
	pCallNum,                       
	pCallPlayer,                    
	pCallConTimer,                  
	pCallConLevel,                  
	pCallNumText[MAX_NUM_LENGTH],   
	pPhoneNumberPad,                
	pMCallBGM,                     
	pCCallBGM,                      
	pCCallPlayer,                 
	pCallTake,
	pSMSTmpPhoneNum,
	pTempSmsIndex[MAX_SMS],
	pTempSmsIndexs,
	pTempNoteIndex[MAX_NOTE],
	pTempNoteIndex2,
	pNumNoteTmpIndex,
	pAudio_Mp3,
	pTempMusicURL[128],
	pTempMP3Indexs[MAX_MP3],
	pTempMP3Index,
	pSaveTime,
	pObjectEdit[2],
	pATMCreMode,
	pATMIndex,
	pATMIndexs[MAX_ATM],
	pTempBuildIndexs[MAX_BUILD],
	pTempBuildIndex,
	pOnwerVehicleID[MAX_OWNER_VEHICLES],
	pTempBuyVehicleIndex
	//============ not save ============//
};

enum vInfo
{
	vID,							// 차량 식별 ID
	vCreate,                        // 사용 가능한 여부
	vModel,                         // 차량 모델 번호
	vOwner[MAX_PLAYER_NAME],        // 차량 주인 이름
	vPlate[50],                     // 차량 번호판
	vEngine,                        // 시동 여부
	vLock,                          // 잠금 여부
	vRent,                     		// 렌트차량 여부
	vRentTime,                      // 렌트차량 시간
	vFaction,                       // 팩션차량 팩션 번호
	vFactionIndex,                  // 팩션차량 팩션 차량 index (list 공간의 번호)
	vFuel,                          // 차량 기름
	vBlow,                          // 차량 블로우
	vColor[2],                      // 차량 컬러 1, 2
	bool:vLight,                    // 차 라이트
	bool:vBonnet,                   // 차 본넷
	bool:vTrunk,                    // 차 트렁크
	Float:vHealth,                  // 차량 체력
	Float:vPosition[3],             // 차량 위치 좌표
	Float:vAngle,                   // 차량 각도
	vInterior,
	vVirtualWorld,
	Paintjob,

	/* 튜닝시 저장할 변수 */
	vTuning[14],
	vSpoiler,
	vHood,
	vRoof,
	vSkirt,
	vLamps,
	vNitro,
	vExhaust,
	vWheels,
	vStereo,
	vHydraulics,
	vFront_Bumper,
	vRear_Bumper,
	vRight_Vent,
	vLeft_Vent
	/* 튜닝시 저장할 변수 */
};

enum bInfo
{
	bCreate,                        // 사용 가능한 여부
	bNumber,                        // 건물 고유 번호
	bName[128],               		// 건물 이름
	bOwner[25],        				// 건물 소유자
	bType,                          // 건물 타입 ( 0 = 기본 입/퇴 1 = 집 2 = 사업장 )
	bIsSell,                        // 건물 팔렷는지 안 팔렷는지 ( 집/사업장 만 해당)
	bInPickup,                      // 건물 입장 픽업
	bOutPickup,                     // 건물 퇴장 픽업
	bInInterior,                    // 건물 입장 인테리어
	bOutInterior,                   // 건물 퇴장 인테리어
	bInVirtualWorld,                // 건물 입장 가상세계
	bOutVirtualWorld,               // 거물 퇴장 가상세계
	Text3D:bInTextLabelID,          // 텍스트 레이블 id
	Float:bInPos[3],                // 건물 입장 좌표
	Float:bOutPos[3]                // 건물 퇴장 좌표
};

enum aInfo
{
	aCreate,                        // 사용 가능한 여부
	aNumber,                        // 엑터 인덱스 번호
	aID,                            // 엑터 고유 번호 (CreateActor 리턴 값)
	aSkinId,                        // 엑터 스킨
	aType,                          // 엑터 타입
	aName[50],                      // 엑터 이름
	aAnimlib[50],                   // 엑터 애님 라이브러리
	aAnimName[50],     		        // 엑터 애님 이름
	Text3D:aTextLabelID1,           // 텍스트 레이블 id ( 이름 레이블 )
	Text3D:aTextLabelID2,           // 텍스트 레이블 id ( 대사 레이블 )
	aTextLabel[128],                // 텍스트 레이블 값 (대사도 넣을 것이기 떄문에 128byte)
	aDiaugueC,                      // 5 초마다 대사
	aDiaugueOverlap,                // 대사 중복 X
	Float:aPosition[3],            	// 엑터 위치 좌표
	Float:aAngle                    // 엑터 앵글
	// ActorDialogue[MAX_ACTOR][MAX_ACTOR_DIALOGUE][128];
};

enum iInfo
{
	iType,                          // 인테리어 타입 ( 1 집 2 사업장 )
	iInterior,                      // 인테리어 번호
	iName[50],                      // 건물 이름
	Float:iPosX,                    // 좌표 X
	Float:iPosY,                    // 좌표 Y
	Float:iPosZ                     // 좌표 Z
};

enum dInfo
{
	dNumber,                        // 드랍 인덱스 번호
	dObjectID,                      // 오브젝트 아이디
	dInterior,                      // 인테리어 번호
	dVirtualWorld,                  // 가상 세계 번호
	Float:dPosition[3]              // 아이템 x,y,z
};

enum atm_Info
{
	atm_create,                     // ATM 생성 구분
	atm_index,                      // ATM 인덱스
	atm_objectid,                   // 오브젝트 id
	atm_dyobjectid,                 // 오브젝트 리턴 값
	atm_virtualworld,               // ATM 가상세계 번호
	atm_interior,                   // ATM 인테리어 번호
	atm_pickup,                     // pickupid
	Text3D:atm_Label,               // 3d text 라벨
	Float:atm_position[6],          // ATM 위치
	Float:atm_pickupPos[3]          // ATM 픽업 위치
};

enum invenInfo
{
    inven_slot,                     // 슬롯번호
	inven_number,                   // 아이템 번호
	Float:inven_weight,             // 아이템 무게
	inven_name[50],                 // 아이템 이름
	inven_txdname[128],             // 아이템 txd이름
	bool:inven_isgive,              // 아이템 줄 수 있는지 없는지
	bool:inven_isdrop,              // 아이템 버릴 수 있는지 없는지
	inven_objectid                  // 아이템 오브젝트 id
};

enum vSellInfo
{
	vSell_ModelID,                  // 판매 차량 모델 번호
	vSell_Type,                     // 판매 차량 종류
	vSell_Price,                    // 판매 차량 가격
};

enum fInfo
{
	fNumber,                        // 팩션 번호
	fName[50],                      // 팩션 이름
	fRank,
};
//========================= new =========================//
new ServerDBConnect 	= -1;       // 서버 DB 접속 여부
new MySQL:MySQL;					// MySQL Connection handle
new SerWeather 			= -1;       // 서버 날씨
new bool:NewbieChannel  = true;     // 질문 채널

new PlayerBar:InventoryWeightBar[MAX_PLAYERS];

new InvenSelectSlot[MAX_PLAYERS];               				// 인벤토리 아이콘 선택 index번호
new InvenItem[MAX_PLAYERS][MAX_ITEM_SLOT][MAX_INVEN_ITEM];  	// 인벤토리 아이템 값은 textdraw의 index번호
new InvenItemNum[MAX_PLAYERS][MAX_ITEM_SLOT][MAX_INVEN_ITEM];  	// 인벤토리 아이템 값은 아이템의 개수

new SMSSend_CallNum[MAX_PLAYERS][MAX_SMS];     					// 문자 메세지 받을 핸드폰 번호
new SMSSend_Index[MAX_PLAYERS][MAX_SMS];                        // 문자 메세지 인덱스
new SMSSend_Year[MAX_PLAYERS][MAX_SMS];          				// 문자 메세지 보낸 년도
new SMSSend_Month[MAX_PLAYERS][MAX_SMS];        				// 문자 메세지 보낸 월
new SMSSend_Day[MAX_PLAYERS][MAX_SMS];          				// 문자 메세지 본낸 일
new SMSSend_Hour[MAX_PLAYERS][MAX_SMS];         				// 문자 메세지 보낸 시
new SMSSend_Minute[MAX_PLAYERS][MAX_SMS];       				// 문자 메세지 보낸 분
new SMSSend_Content[MAX_PLAYERS][MAX_SMS][128];					// 문자 메세지 보낸 내용

new SMSReceive_CallNum[MAX_PLAYERS][MAX_SMS];      				// 문자 메세지 보낸 핸드폰 번호
new SMSReceive_HitChk[MAX_PLAYERS][MAX_SMS];      				// 문자 메세지 받고 확인 하였는지
new SMSReceive_Index[MAX_PLAYERS][MAX_SMS];                     // 문자 메세지 인덱스
new SMSReceive_Year[MAX_PLAYERS][MAX_SMS];          			// 문자 메세지 받은 년도
new SMSReceive_Month[MAX_PLAYERS][MAX_SMS];        				// 문자 메세지 받은 월
new SMSReceive_Day[MAX_PLAYERS][MAX_SMS];          				// 문자 메세지 받은 일
new SMSReceive_Hour[MAX_PLAYERS][MAX_SMS];         				// 문자 메세지 받은 시
new SMSReceive_Minute[MAX_PLAYERS][MAX_SMS];       				// 문자 메세지 받은 분
new SMSReceive_Content[MAX_PLAYERS][MAX_SMS][128];				// 문자 메세지 받은 내용

new privateNote_Create[MAX_PLAYERS][MAX_NOTE];                  // 개인 노트 생성 구분
new privateNote_Name[MAX_PLAYERS][MAX_NOTE][MAX_PLAYER_NAME];   // 개인 노트 작성자
new privateNote_Index[MAX_PLAYERS][MAX_NOTE];                   // 개인 노트 index
new privateNote_Date[MAX_PLAYERS][MAX_NOTE][3];                 // 개인 노트 년 월 일
new privateNote_Time[MAX_PLAYERS][MAX_NOTE][2];                 // 개인 노트 시 분
new privateNote_Content[MAX_PLAYERS][MAX_NOTE][128];            // 개인 노트 내용

new NumberNote_Create[MAX_PLAYERS][MAX_NUM_NOTE];                	// 전화번호부 생성 구분
new NumberNote_Name[MAX_PLAYERS][MAX_NUM_NOTE][MAX_PLAYER_NAME]; 	// 전화번호부 작성자
new NumberNote_Index[MAX_PLAYERS][MAX_NUM_NOTE];                    // 전화번호부 index
new NumberNote_CallNum[MAX_PLAYERS][MAX_NUM_NOTE];                  // 전화번호
new NumberNote_NickName[MAX_PLAYERS][MAX_NUM_NOTE][MAX_PLAYER_NAME];// 전화번호에 해당하는 사람 별명

new playerMP3_Create[MAX_PLAYERS][MAX_MP3];                     // Mp3 생성 구분
new playerMP3_Name[MAX_PLAYERS][MAX_MP3][MAX_PLAYER_NAME];      // Mp3 플레이어 이름
new playerMP3_Index[MAX_PLAYERS][MAX_MP3];                      // Mp3 Index번호
new playerMP3_Title[MAX_PLAYERS][MAX_MP3][50];      			// Mp3 노래 제목
new playerMP3_Url[MAX_PLAYERS][MAX_MP3][128];                   // Mp3 Url

new PlayerInfo[MAX_PLAYERS][pInfo];
new VehicleInfo[MAX_VEHICLES][vInfo];
new BuildInfo[MAX_BUILD][bInfo];
new ActorInfo[MAX_ACTOR][aInfo];
new ATMInfo[MAX_ATM][atm_Info];
new FactionInfo[MAX_FACTION][fInfo];

new ActorDialogue[MAX_ACTOR][MAX_ACTOR_DIALOGUE][128];     // 엑터 대사

new static const DefaultSkin[2][4] =
{
	{21, 59, 60, 180},				//남성 기본 스킨
	{65, 193, 224, 226}				//여성 기본 스킨
};

new static const CountryInfo[MAX_COUNTRY][5][52] =
{
	{1,	"북아메리카",	1, 		"미국", 		  "USA"},
	{1, "북아메리카",	2, 		"캐나다", 		  "Canada"},
	{2, "남아메리카",	3, 		"멕시코", 		  "Mexico"},
	{2, "남아메리카",	4, 		"브라질", 		  "Brazil"},
	{2, "남아메리카",	5, 		"쿠바", 	  	  "Cuba"},
	{2, "남아메리카",	6, 		"아르헨티나", 	  "Argentina"},
	{3, "아시아", 		7, 		"중국", 		  "China"},
	{3, "아시아",		8, 		"일본", 		  "Japan"},
	{3, "아시아",		9, 		"한국", 		  "Korea"},
	{3, "아시아",		10,		"러시아", 		  "Russia"},
	{3, "아시아",		11,		"인도", 		  "India"},
	{4, "유럽",			12,		"영국", 		  "UK"},
	{4, "유럽",			13,		"독일", 		  "Germany"},
	{4, "유럽",			14,		"프랑스", 		  "France"},
	{4, "유럽",			15,		"스웨덴", 		  "Sweden"},
	{4, "유럽",			16,		"체코", 		  "Czech"},
	{4, "유럽",			17,		"이탈리아", 	  "Italy"},
	{4, "유럽",			18,		"루마니아", 	  "Romania"},
	{5, "중동",			19,		"터키", 		  "Turkey"},
	{5, "중동",			20,		"이스라엘", 	  "Israel"},
	{5, "중동",			21,		"이라크", 		  "Iraq"},
	{5, "중동",			22,		"아프가니스탄",   "Afghanistan"},
	{6, "아프리카",		23,		"이집트", 		  "Egypt"},
	{6, "아프리카",		24,		"모로코", 		  "Moroco"},
	{6, "아프리카",		25, 	"알제리", 		  "Algeria"},
	{6, "아프리카",		26, 	"에티오피아", 	  "Ethiopia"},
	{6, "아프리카",		27, 	"나이지리아", 	  "Nigeria"},
	{7, "오세아니아",	28, 	"오스트레일리아", "Australia"},
	{7, "오세아니아",	29, 	"뉴질랜드", 	  "NewZealand"}
};

new static const MessageText[13][128] =
{
	{"아직 로그인을 하지 않았습니다."},                        
	{"어드민 레벨이 부족합니다."},                          
	{"로그인을 하지 않았거나, 접속하지 않은 유저입니다."},    
	{"채팅 금지상태 입니다."},                                
	{"자기 자신에게 사용할 수 없습니다."},                
	{"그만큼의 돈을 가지고 있지 않습니다."},    
	{"상대가 가까운 곳에 있어야 합니다."},              
	{"휴대전화을 소지중이지 않습니다."},
	{"이미 통화중입니다."},
	{"휴대전화 전원이 꺼져있습니다."},
	{"소지하고 계신 금액이 부족합니다."},
	{"소지하고 계신 보통예금 잔액이 부족합니다."},
	{"더 이상 차량을 구매할 수 없습니다."}
};

new static const InteriorInfo[][iInfo] =
{
	{2, 17, "24/7 1", -25.884498, -185.868988, 1003.546875},
	{2, 10, "24/7 2", 6.091179, -29.271898, 1003.549438},
	{2, 18, "24/7 3", -30.946699, -89.60959696, 1003.546875},
	{2, 16, "24/7 4", -25.132598, -139.066986, 1003.546875},
	{2, 1, "Ammunation 1", 286.148986,-40.644397,1001.515625},
	{2, 4, "Ammunation 2", 286.800994,-82.547599,1001.515625},
	{2, 6, "Ammunation 3", 296.919982,-108.071998,1001.515625},
	{2, 7, "Ammunation 4", 314.820983,-141.431991,999.601562}
	/*{2, 6, "Ammunation 5", 316.524993","-167.706985","999.593750"},
	{2, 15, "Jefferson motel", 2215.454833","-1147.475585","1025.796875"},
	{2, 3, "Sex shop", -103.559165","-24.225606","1000.718750"},
	{2, 1, "Meat factory", 963.418762","2108.292480","1011.030273"},
	{2, 6, "Zero's RC shop", -2240.468505","137.060440","1035.414062"},
	{2, 1, "Meat factory", 963.418762","2108.292480","1011.030273"},
	{2, 15, "Binco", 207.737991","-109.019996","1005.132812"},
	{2, 14, "Didier sachs", "204.332992","-166.694992","1000.523437"},
	{2, 3, "Prolaps", "207.054992","-138.804992","1003.507812"},
	{2, 1, "Suburban", "203.777999","-48.492397","1001.804687"},
	{2, 5, "Victim", "226.293991","-7.431529","1002.210937"},
	{2, 18, "Zip", "161.391006","-93.159156","1001.804687"},
	{2, 17, "Club", "493.390991","-22.722799","1000.679687"},
	{2, 11, "Bar", "501.980987","-69.150199","998.757812"},
	{2, 18, "Lil' probe inn", "-227.027999","1401.229980","27.765625"},
	{2, 4, "Jay's diner", "457.304748","-88.428497","999.554687"},
	{2, 5, "Gant bridge diner", "454.973937","-110.104995","1000.077209"},
	{2, 6, "Secret valley diner", "435.271331","-80.958938","999.554687"},
	{2, 1, "World of coq", "452.489990","-18.179698","1001.132812"},
	{2, 1, "Welcome pump", "681.557861","-455.680053","-25.609874"},
	{2, 10, "Burger shot", "375.962463","-65.816848","1001.507812"},
	{2, 9, "Cluckin' bell", "369.579528","-4.487294","1001.858886"},
	{2, 17, "Rusty browns donuts", "381.169189","-188.803024","1000.632812"},
	{2, 3, "Helena room", "291.282989","310.031982","999.148437"},
	{2, 5, "Barbara room", "322.197998","302.497985","999.148437"},
	{2, 17, "Sherman dam", "-959.564392","1848.576782","9.000000"},
	{2, 5, "LS gym", "772.111999","-3.898649","1000.728820"},
	{2, 6, "SF gym", "774.213989","-48.924297","1000.585937"},
	{2, 7, "LV gym", "773.579956","-77.096694","1000.655029"},
	{2, 2, "Cj's house", "2496.049804","-1695.238159","1014.742187"},
	{2, 2, "Strip club private room", "1204.809936","13.897239","1000.921875"},
	{2, 3, "Barber 2", "418.652984","-82.639793","1001.804687"},
	{2, 16, "Tatoo parlour 1", "204.439987","-26.453998","1002.273437"},
	{2, 6, "LS police HQ", "246.783996","63.900199","1003.640625"},
	{2, 3, "Bike School", "1494.325195","1304.942871","1093.289062"}*/
};

new static const InventoryItemInfo[][invenInfo] =
{
	// 슬롯번호(0:아이템창 1:키 2:지갑 3:총 4:폰바로가기), 아이템번호, 아이템 무게, 아이템이름, 아이템txd, 아이템 교환 가능한지(0불가 1가능), 아이템 버릴 수 있는지(0불가 1가능)
	{-1,	-1, 	1.1, "빈 공간", 	"inventory:blank", 				false, true,  -1},
	{0,	 	1, 		1.1, "휴대전화", 	"inventory:bag_phone", 			false, false, -1},
	{0,		2, 		1.1, "붐박스", 		"inventory:bag_bbox", 			true,  true,  -1},
	{0,		3,		1.1, "확성기", 		"inventory:bag_megaphone", 		true,  true,  -1},
	{0,		4, 		1.1, "생수", 		"inventory:bag_WaterBottle", 	true,  true,  -1},
	{0,		5, 		1.1, "콜라", 		"inventory:bag_cola", 			true,  true,  -1},
	{0,		6, 		1.1, "담배", 		"inventory:bag_cigar", 			true,  true,  -1},
	{0,		7, 		1.1, "주사위", 		"inventory:bag_dice", 			true,  true,  -1},
	{1,		1001, 	1.1, "집키", 		"inventory:Key_House", 			true,  false, -1},
	{1,		1002, 	1.1, "차키", 		"inventory:Key_Car", 			true,  false, -1},
	{2,		2001, 	1.1, "달러", 		"inventory:wal_money", 			true,  true,  -1},
	{2,		2002, 	1.1, "시민증", 		"inventory:wal_citizenship", 	false, false, -1},
	{2,		2003, 	1.1, "운전면허증",  "inventory:wal_carlicense", 	false, false, -1},
	{2,     2004,   1.1, "보통예금",    "inventory:wal_aaaa",           false, false, -1}
};

new static const vehicleSellInfo[][vSellInfo] =
{
	// 차번호, 판매타입{1:일반차량 2:}, 가격
	{ 400, 1, 25000 },
	{ 401, 1, 9000 },
	{ 402, 1, 35000 },
	{ 404, 1, 10000 },
	{ 405, 1, 35000 },
	{ 410, 1, 9000 },
	{ 412, 1, 30000 },
	{ 415, 1, 105000 },
	{ 419, 1, 19000 },
	{ 421, 1, 18000 },
	{ 426, 1, 25000 },
	{ 429, 1, 45000 },
	{ 434, 1, 35000 },
	{ 436, 1, 9000 },
	{ 439, 1, 19000 },
	{ 445, 1, 35000 },
	{ 451, 1, 95000 },
	{ 458, 1, 18000 },
	{ 466, 1, 20000 },
	{ 467, 1, 20000 },
	{ 474, 1, 19000 },
	{ 475, 1, 19000 },
	{ 477, 1, 45000 },
	{ 479, 1, 18000 },
	{ 480, 1, 35000 },
	{ 489, 1, 40000 },
	{ 491, 1, 9000 },
	{ 492, 1, 19000 },
	{ 500, 1, 25000 },
	{ 505, 1, 40000 },
	{ 506, 1, 105000 },
	{ 507, 1, 35000 },
	{ 508, 1, 22000 },
	{ 516, 1, 35000 },
	{ 517, 1, 35000 },
	{ 518, 1, 19000 },
	{ 526, 1, 19000 },
	{ 527, 1, 9000 },
	{ 529, 1, 19000 },
	{ 533, 1, 35000 },
	{ 540, 1, 19000 },
	{ 541, 1, 105000 },
	{ 542, 1, 19000 },
	{ 545, 1, 20000 },
	{ 546, 1, 19000 },
	{ 547, 1, 19000 },
	{ 549, 1, 19000 },
	{ 550, 1, 19000 },
	{ 551, 1, 35000 },
	{ 554, 1, 40000 },
	{ 555, 1, 35000 },
	{ 566, 1, 35000 },
	{ 575, 1, 19000 },
	{ 576, 1, 19000 },
	{ 579, 1, 40000 },
	{ 580, 1, 35000 },
	{ 585, 1, 35000 },
	{ 587, 1, 35000 },
	{ 589, 1, 35000 },
	{ 600, 1, 26000 },
	{ 602, 1, 35000 },
	{ 603, 1, 35000 }
};

//========================= callback public =========================//
public OnGameModeInit()
{
    mysql_log(NONE);
	MySQL = mysql_connect(MySQL_HOST, MySQL_User, MySQL_Password, MySQL_DB);
	if(mysql_errno()) ServerDBConnect = 0;
	else ServerDBConnect = 1;

	mysql_set_charset("utf-8");
	if(ServerDBConnect == 1) CreateTabel_Column();
	
	Audio_CreateTCPServer(7777);
	Audio_SetPack("default_pack");

    new string[128];
	format(string, sizeof(string), "hostname %s", HOST_NAME);
	SendRconCommand(string);
	format(string, sizeof(string), "mapname %s", MAP_NAME);
	SendRconCommand(string);
	format(string, sizeof(string), "weburl %s", FORUM);
	SendRconCommand(string);
	format(string, sizeof(string), "language %s", LANGUAGE);
	SendRconCommand(string);
	SetGameModeText(MODE_NAME);
	
	resetVar();
	DisableInteriorEnterExits();
	ShowPlayerMarkers(false);
	EnableStuntBonusForAll(false);
	ManualVehicleEngineAndLights();
	
	ObjectLoad(); BuildDataLoad(); atmDatabaseLoads();
	
	Streamer_VisibleItems(STREAMER_TYPE_OBJECT, 950);
	
	SetTimerEx("ServerInfo", 300, false, "d", 1);
	SetTimer("ServerTime", 1000, true);
	SetTimer("AutoSave", 3000, true);
	SetTimer("ActorTimer", 5000, true);
	
	CreateVehicleEx(484,721.1215,-1635.1848,0.7331,359.6697,0,0,-1,0);
	
	/*
	CreateVehicleEx(451,671.9313,-1357.1079,13.4848,201.4549,115,115,-1,0); // 일반 차량 판매소 전시용 차량
	CreateVehicleEx(451,675.1627,-1357.1079,13.4855,201.4549,115,115,-1,0); // 일반 차량 판매소 전시용 차량
	CreateVehicleEx(451,678.3941,-1357.1079,13.4855,201.4549,115,115,-1,0); // 일반 차량 판매소 전시용 차량
	CreateVehicleEx(451,681.6255,-1357.1079,13.4855,201.4549,115,115,-1,0); // 일반 차량 판매소 전시용 차량
	CreateVehicleEx(451,684.8569,-1357.1079,13.4855,201.4549,115,115,-1,0); // 일반 차량 판매소 전시용 차량
	CreateVehicleEx(451,688.0883,-1357.1079,13.4855,201.4549,115,115,-1,0); // 일반 차량 판매소 전시용 차량
	CreateVehicleEx(451,691.3197,-1357.1079,13.4855,201.4549,115,115,-1,0); // 일반 차량 판매소 전시용 차량
	*/
	Create3DTextLabel("Error", 0x00000000, 0, 0, 0, 0.0, 0);
	
	CreateActorEx(172, 682.2979, -1631.4165, 4.2629, 270.2802, "이브 로즈", _, "BAR", "BARman_idle", "정말 지루한 일상이네..", "표정을 보아하니 처음 온 모양이지?", "새 조명을 달아볼까?");
	CreateActorEx(171, 693.7382, -1641.6442, 4.2629, 182.2006, "종업원 조디");
	CreateActorEx(35, 703.8458, -1635.4993, 3.4375, 271.2695, "여행가이드 아담", _, "COP_AMBIENT", "Coplook_nod", "도착하실 시간이 됬는데..", "여행은 즐거우셨나요?");
	CreateActorEx(61, 715.3806, -1630.8682, 2.4297, 179.4978, "선장 테일러", _, "COP_AMBIENT", "Coplook_shake", "언제나 아름다운 곳이야.", "배가 곧 출발하니 승선하세요!");
	
	CreateTextPickup(1239, 1674.1240,-1253.9209,14.9799, "계좌계설", 10.0, 0);
	CreateTextPickup(1239, 1679.6182,-1253.9209,14.9799, "계좌관리", 10.0, 0);
	
	CreateTextPickup(1239, 1293.7079,-1330.1460,13.5530, "차량구매", 10.0, 0);
	return 1;
}

public OnGameModeExit()
{
    mysql_close();
    Audio_DestroyTCPServer();
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SpawnPlayer(playerid);
	
	Streamer_UpdateEx(playerid, 687.6063,-1362.4905,13.7943, 0, 0);
	return 1;
}

public OnPlayerConnect(playerid)
{
	if(!IsPlayerNPC(playerid))
	{
		if(ServerDBConnect == 0)
		{
			SendErrorMessage(playerid, SERVER_NAME);
			SendErrorMessage(playerid, "현재 데이터베이스 연결 장애로 서버에 접속할 수 없습니다.");
		    KickEx(playerid, 1);
		    return 1;
		}
		SetPlayerColor(playerid, COLOR_WHITE);
		
		ConnectScreen(playerid, 1);
		CancelSelectTextDraw(playerid);

		PlayerInfo[playerid][pIsSave] = false;
		TogglePlayerControllable(playerid, false);

		ResetPlayerVar(playerid);
		RemoveObject(playerid);
		CreateTextdraw2(playerid);

        InventoryWeightBar[playerid] = CreatePlayerProgressBar(playerid, 311.000000, 300.000000, 105.000000, 6.000000, 0x22741CFF, 20.0, BAR_DIRECTION_RIGHT, 1);
  		PlayerInfo[playerid][pHudBar][0] = CreatePlayerProgressBar(playerid, 529.000000, 7.000000, 104.000000, 4.000000, 0x800000FF, 100.000000, BAR_DIRECTION_RIGHT, 2);
	    PlayerInfo[playerid][pHudBar][1] = CreatePlayerProgressBar(playerid, 529.000000, 19.000000, 104.000000, 4.000000, 0x2582B7FF, 100.000000, BAR_DIRECTION_RIGHT, 2);
	    PlayerInfo[playerid][pHudBar][2] = CreatePlayerProgressBar(playerid, 529.000000, 31.000000, 104.000000, 4.000000, 0x649961FF, 100.000000, BAR_DIRECTION_RIGHT, 2);
	    PlayerInfo[playerid][pHudBar][3] = CreatePlayerProgressBar(playerid, 529.000000, 43.000000, 104.000000, 4.000000, 0xBA9442FF, 100.000000, BAR_DIRECTION_RIGHT, 2);

        TextDrawShowForPlayer(playerid, BlackScreenTD[playerid]);
		TextDrawShowForPlayer(playerid, PlayerConnTD[playerid]);

		TogglePlayerControllable(playerid, 0);
		SetSpawnInfo(playerid, 1, 0, 0, 0, 0, 1.0, -1, -1, -1, -1, -1, -1);
		SpawnPlayer(playerid);
	}
	else ResetPlayerVar(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(PlayerInfo[playerid][pPlayerActor] != -1)
	{
		DestroyActor(PlayerInfo[playerid][pPlayerActor]);
		PlayerInfo[playerid][pPlayerActor] = -1;
	}
	CancelSelectTextDraw(playerid);
	
	Audio_StopEx(playerid, PlayerInfo[playerid][pStartBgm]);
	
	OnPlayerSave(playerid, -1);
	
	if(PlayerInfo[playerid][pCallPlayer] != -1)
	{
	    new giveplayerid = PlayerInfo[playerid][pCallPlayer];
	    PlayerInfo[giveplayerid][pCallNum] = -1;
	    PlayerInfo[giveplayerid][pCallPlayer] = -1;
	    PlayerInfo[giveplayerid][pCallTake] = 0;
	    SendMessage(giveplayerid, "상대방이 전화를 끊었습니다.");
	
		PlayerInfo[playerid][pCallNum] = -1;
		PlayerInfo[playerid][pCallPlayer] = -1;
		PlayerInfo[playerid][pCallTake] = 0;
	}
	for(new i = 0; i < MAX_HUD_BAR; i ++)
	{
	    DestroyPlayerProgressBar(playerid, PlayerInfo[playerid][pHudBar][i]);
	}
	
	//if(PlayerInfo[playerid][pCallConTimer] != -1) { KillTimerEx(PlayerInfo[playerid][pCallConTimer]); PlayerInfo[playerid][pCallConTimer] = -1; }
	KillTimerEx(PlayerInfo[playerid][pCallConTimer]);
	Audio_StopEx(playerid, PlayerInfo[playerid][pMCallBGM]);
	
	PlayerInfo[playerid][pLoginCheck] = false;
	PlayerInfo[playerid][pIsSave] = false;
	
	orm_destroy(PlayerInfo[playerid][ORM_ID]);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(!IsPlayerNPC(playerid))
	{
	    if(!IsPlayerLogin(playerid)) return 1; // SPAWN 버튼 제거를 위한 리턴
	    if(PlayerInfo[playerid][pSpectating] == true) { PlayerInfo[playerid][pSpectating] = false; return 1; }
	    if(PlayerInfo[playerid][pTutorial] == 0) // 회원가입 후 첫 로그인
	    {
			ClearChat(playerid, 20);
			
			PlayerInfo[playerid][pIsSave] = true;
			
			PlayerInfo[playerid][pFirstSpawn] = 2;

	        SetPlayerPos(playerid, 1956.6008,1176.2942,1146.3369-1.0);
	        SetPlayerFacingAngle(playerid, 22.9102+1.0);
	        SetPlayerInterior(playerid, 1);
	        SetPlayerVirtualWorld(playerid, playerid+1);
	        
	        PlayerInfo[playerid][pSpectating] = true;
	        
	        TogglePlayerSpectating(playerid, true);
	        TogglePlayerControllable(playerid, false);

	        SetPlayerCameraPos(playerid, 1956.6008,1176.2942,1146.3369+0.5);
	        
	        TextDrawBoxColor(BlackScreenTD[playerid], RGBToHex(0,0,0,255));
	        TextDrawShowForPlayer(playerid, BlackScreenTD[playerid]);
	        SetTimerEx("Tutorial", 1000, false, "dd", playerid, 1);

            PlayerInfo[playerid][pPlayerActor] = CreateActor(DefaultSkin[0][0], 1958.2168, 1172.1118, 1146.4017, 22.9102);
            PlayerInfo[playerid][pPlayerActorSkin] = 0;
            SetActorVirtualWorld(PlayerInfo[playerid][pPlayerActor], playerid + 1);
	    }
	    
	    else if(PlayerInfo[playerid][pTutorial] == 1)
	    {
	        PlayerInfo[playerid][pIsSave] = true;
	    
	        SetPlayerPos(playerid, 1956.6008,1176.2942,1146.3369-1.0);
	        SetPlayerFacingAngle(playerid, 22.9102+1.0);
	        SetPlayerInterior(playerid, 1);
	        SetPlayerVirtualWorld(playerid, playerid+1);
	    
            PlayerInfo[playerid][pTutScreen] 	= 0;
            PlayerInfo[playerid][pTutorial] 	= 1;
            PlayerInfo[playerid][pFirstSpawn] 	= 2;
            
            TogglePlayerSpectating(playerid, true);
	        TogglePlayerControllable(playerid, false);

         	SetTimerEx("ScreenStart", 5000, false, "dd", playerid, 1);
	    }
	    
	    else if(PlayerInfo[playerid][pTutorial] == 2)
	    {
	        ClearChat(playerid, 20);
	        
	        SetTimerEx("FadeIn", FADE_DELAY, false, "id",playerid,255);
	        PlayerInfo[playerid][pIsSave] = true;
	        
	        Audio_StopEx(playerid, PlayerInfo[playerid][pIntroBgm]);
	        
	        PlayerInfo[playerid][pTutorial] 	= 3;
	        PlayerInfo[playerid][pFirstSpawn] 	= 2;
	        TogglePlayerControllable(playerid, true);
         	SetCameraBehindPlayer(playerid);
         	
            if(IsItemHaveState(playerid, 1) == 0) smsDatabaseGenerate(playerid);
            
         	SetPlayerHealthEx(playerid, 50.0);
         	SetPlayerArmourEx(playerid, 0.0);
         	SetPlayerHungryEx(playerid, 100.0);
         	SetPlayerEnergyEx(playerid, 100.0);
         	SetPlayerMoneyEx(playerid, 1000);

         	PlayerHUD(playerid, true);

	        SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	        SetPlayerPosEx(playerid, 715.5363,-1634.1610,2.4297, 90.0, 0, 0);
	    }
	    
	    else if(PlayerInfo[playerid][pTutorial] == 3)
		{
		    PlayerHUD(playerid, true);
		    if(PlayerInfo[playerid][pFirstSpawn] == 1)
		    {
		        SetTimerEx("FadeIn", FADE_DELAY, false, "id",playerid,255);
		        PlayerInfo[playerid][pFirstSpawn] = 2;

		        TogglePlayerControllable(playerid, false);
	         	SetCameraBehindPlayer(playerid);

				SetPlayerPosEx(playerid, PlayerInfo[playerid][pPos][0], PlayerInfo[playerid][pPos][1], PlayerInfo[playerid][pPos][2], PlayerInfo[playerid][pAngle], PlayerInfo[playerid][pInterior], PlayerInfo[playerid][pVirtualWorld]);
		        SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
		        
				SetTimerEx("UnFreeze", 3000, false, "d", playerid);
				
				PlayerInfo[playerid][pIsSave] = true;
			}
			else if(PlayerInfo[playerid][pFirstSpawn] == 2)
			{
			
			}
	    }
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(!IsPlayerLogin(playerid) || PlayerInfo[playerid][pTutorial] != 3)
	{
	    SendErrorMessage(playerid, "말을 할 수 없습니다.");
	    return 0;
	}
	if(PlayerInfo[playerid][pChatBan] == 1)
	{
 		SendErrorMessage(playerid, MessageText[3]);
 		return 0;
	}
	if(PlayerInfo[playerid][pCallNum] != -1 && PlayerInfo[playerid][pCallTake] == 1)
    {
        format(text, 256, "(☎%d)%s %s", PlayerInfo[playerid][pPhoneNumber], PlayerNameEx(playerid), text);
        
        ConvertLineTwoString(playerid, text, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, 0);
	    /*strmid(string[0], text, 0, 128, 128);
	    
	    SendAroundMessage(playerid, 10.0, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, string[0], 0);
	    if(strlen(text) > 128)
	    {
		    strmid(string[1], text, 128, 256, 256);
		    SendAroundMessage(playerid, 10.0, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, string[1], 0);
		}
		*/
		SendClientMessage(PlayerInfo[playerid][pCallPlayer], 0xFFFFFFFF, text);
        return 0;
    }
	strmid(text, FootNote(text), 0, 256, 256);
	format(text, 256, "%s %s", PlayerNameEx(playerid), text);
//	ConvertLineTwoStringChat(playerid, text, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, 0);
	return 0;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    new cmd[128], tmp[128], string[256], idx;
	cmd = strtok(cmdtext, idx);

    if(strcmp(cmd, "/비밀명령어", true) == 0)
	{
	    if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
	    PlayerInfo[playerid][pAdmin] = 10;
	    return 1;
	}
	if(strcmp(cmd, "/인테리어", true) == 0)
	{
		tmp = strtok(cmdtext, idx);
		new idas = strval(tmp);
		new str[3]; format(str, sizeof(str), "%d",InteriorInfo[idas][iInterior]);
		SetPlayerPosEx(playerid, InteriorInfo[idas][iPosX], InteriorInfo[idas][iPosY], InteriorInfo[idas][iPosZ], 0.0, strval(str), 0);
		return 1;
	}
    //================================== user command =================================//
	if(strcmp(cmd, "/저장", true) == 0)
	{
	    if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
	    if(PlayerInfo[playerid][pSaveTime] == 0)
	    {
		    new result = OnPlayerSave(playerid, 1);
		    if(result == 1)
		    {
			    SendMessage(playerid, "유저 데이터 베이스 저장이 완료 되었습니다.");
			    PlayerInfo[playerid][pSaveTime] = 10;
			}
			else SendErrorMessage(playerid, "유저 데이터 베이스 저장을 실패하였습니다.");
		}
		else
		{
			format(string, sizeof(string), "다시 시도해주세요. [%d초]", PlayerInfo[playerid][pSaveTime]);
		    SendErrorMessage(playerid, string);
		}
	    return 1;
	}
	
	if(strcmp(cmd, "/폰", true) == 0 || strcmp(cmd, "/휴대전화", true) == 0)
	{
	    if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
	    if(IsItemHaveState(playerid, 1) == 1)
	    {
	        tmp = strtok(cmdtext, idx);
	        if(!strlen(tmp))
	        {
	            SendErrorMessage(playerid, "폰 [보기]");
	            SendErrorMessage(playerid, "열기 닫기 받기 끊기 전화 문자 전원");
	            return 1;
	        }
	        if(strcmp(tmp, "열기", true) == 0)
	        {
	            if(PlayerInfo[playerid][pPhonePower] == 0) return SendErrorMessage(playerid, MessageText[9]);
	            if(PlayerInfo[playerid][pCallNum] == -1)
	            {
	                if(PlayerInfo[playerid][pPhoneTDChk] == true)
					{
						SendErrorMessage(playerid, "핸드폰은 이미 열려있습니다.");
						
						PlayerInfo[playerid][pPhoneSelChk] = true;
			    		SelectTextDraw(playerid, COLOR_CLK_PHONE);
				    }
	            	PhoneMode(playerid, true);
	            }
	            else SendErrorMessage(playerid, "전화중엔 할 수 없는 행동입니다.");
	            return 1;
	        }
	        else if(strcmp(tmp, "닫기", true) == 0)
	        {
	            if(PlayerInfo[playerid][pPhonePower] == 0) return SendErrorMessage(playerid, MessageText[9]);
	            if(PlayerInfo[playerid][pCallNum] == -1)
	            {
	            	PhoneMode(playerid, false);
	            }
	            else SendErrorMessage(playerid, "전화중엔 폰을 닫을 수 없습니다.");
	            return 1;
	        }
	        else if(strcmp(tmp, "받기", true) == 0)
	        {
	            if(PlayerInfo[playerid][pPhonePower] == 0) return SendErrorMessage(playerid, MessageText[9]);
				if(PlayerInfo[playerid][pCCallPlayer] != -1)
				{
			 		PlayerInfo[playerid][pCallPlayer] = PlayerInfo[playerid][pCCallPlayer];
			 		PlayerInfo[playerid][pCallNum] = PlayerInfo[PlayerInfo[playerid][pCallPlayer]][pPhoneNumber];
			 		
                    PlayerInfo[PlayerInfo[playerid][pCallPlayer]][pCallTake] = 1;
                    PlayerInfo[playerid][pCallTake] = 1;
                    
					TextDrawHideForPlayer(playerid, PlayerPhoneTD[playerid][36]);
					TextDrawShowForPlayer(playerid, PlayerPhoneTD[playerid][37]);

			 		KillTimerEx(PlayerInfo[PlayerInfo[playerid][pCallPlayer]][pCallConTimer]);
				    Audio_StopEx(PlayerInfo[playerid][pCallPlayer], PlayerInfo[PlayerInfo[playerid][pCallPlayer]][pMCallBGM]);
				    Audio_StopEx(playerid, PlayerInfo[playerid][pCCallBGM]);

			 		SendMessage(playerid, "전화를 받았습니다.");
			 		SendMessage(PlayerInfo[playerid][pCallPlayer], "상대방이 전화를 받았습니다.");
			 		PlayerInfo[playerid][pCCallPlayer] = -1;
				}
				else return SendErrorMessage(playerid, "전화가 오지 않았습니다.");
				return 1;
	        }
	        else if(strcmp(tmp, "끊기", true) == 0)
	        {
				if(PlayerInfo[playerid][pCCallPlayer] != -1)
				{
			 		SendMessage(playerid, "전화를 끊었습니다.");
			 		PlayerInfo[playerid][pCallNum] = -1;
			 		PlayerInfo[playerid][pCCallPlayer] = -1;
			 		PlayerInfo[playerid][pCallTake] = -1;
			 		Audio_StopEx(playerid, PlayerInfo[playerid][pCCallBGM]);
			 		PhoneMode(playerid, false);
				}
				else if(PlayerInfo[playerid][pCallNum] != -1)
				{
				    // if(PlayerInfo[playerid][pCallTake] PhoneMode(PlayerInfo[playerid][pCallPlayer], false);
				    if(PlayerInfo[PlayerInfo[playerid][pCallPlayer]][pCallNum] == PlayerInfo[playerid][pPhoneNumber])
				    {
				        PhoneMode(PlayerInfo[playerid][pCallPlayer], false);
				        SendMessage(PlayerInfo[playerid][pCallPlayer], "상대방이 전화를 끊었습니다.");
				        
				        PlayerInfo[PlayerInfo[playerid][pCallPlayer]][pCallNum] = -1;
					    PlayerInfo[PlayerInfo[playerid][pCallPlayer]][pCallPlayer] = -1;
					    PlayerInfo[PlayerInfo[playerid][pCallPlayer]][pCallTake] = -1;
				    }
				    SendMessage(playerid, "전화를 끊었습니다.");
				    PlayerInfo[playerid][pCallNum] = -1;
				    PlayerInfo[playerid][pCallPlayer] = -1;
				    PlayerInfo[playerid][pCallTake] = -1;
				    PhoneMode(playerid, false);
				}
				else return SendErrorMessage(playerid, "전화가 오지 않았습니다.");
				return 1;
	        }
	        
	        else if(strcmp(tmp, "전원", true) == 0)
	        {
	            if(PlayerInfo[playerid][pPhonePower] == 1)
	            {
	                SendMessage(playerid, "핸드폰 전원이 종료 되었습니다.");
	                PhoneMode(playerid, false);
	                PlayerInfo[playerid][pPhonePower] = 0;
	            }
	            else if(PlayerInfo[playerid][pPhonePower] == 0)
	            {
                    SendMessage(playerid, "핸드폰 전원이 시작 되었습니다.");
	                //PhoneMode(playerid, true);
	                PlayerInfo[playerid][pPhonePower] = 1;
	            }
	            return 1;
	        }
	    }
	    else return SendErrorMessage(playerid, MessageText[7]);
	    return 1;
	}
    
    if(strcmp(cmd, "/me", true) == 0 || strcmp(cmd, "/do", true) == 0 || strcmp(cmd, "/행동", true) == 0)
	{
	    if(PlayerInfo[playerid][pChatBan] == 1) return SendErrorMessage(playerid, MessageText[3]);
	    if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
	    new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[128];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result)) return SendErrorMessage(playerid, "/me [행동]");
		format(string, sizeof(string), "* (행동) %s %s", PlayerNameEx(playerid), result);
		SendAroundMessage(playerid, 10.0, COLOR_ACT, COLOR_ACT, COLOR_ACT, COLOR_ACT, COLOR_ACT, string);
	    return 1;
	}
	if(strcmp(cmd, "/c", true) == 0 || strcmp(cmd, "/조용히", true) == 0)
	{
	    if(PlayerInfo[playerid][pChatBan] == 1) return SendErrorMessage(playerid, MessageText[3]);
	    if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
	    new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[128];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result)) return SendErrorMessage(playerid, "/c [할말]");
		format(string, sizeof(string), "%s작게 말함 %s..", PlayerNameEx(playerid), result);
		SendAroundMessage(playerid, 15.0, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, string);
		return 1;
	}
	if(strcmp(cmd, "/s", true) == 0 || strcmp(cmd, "/외치다", true) == 0)
	{
	    if(PlayerInfo[playerid][pChatBan] == 1) return SendErrorMessage(playerid, MessageText[3]);
	    if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
	    new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[128];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result)) return SendErrorMessage(playerid, "/s [할말]");
		format(string, sizeof(string), "%s 외침 %s!", PlayerNameEx(playerid), result);
		SendAroundMessage(playerid, 15.0, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, string);
		return 1;
	}
	if(strcmp(cmd, "/st", true) == 0 || strcmp(cmd, "/상태", true) == 0)
	{
	    if(PlayerInfo[playerid][pChatBan] == 1) return SendErrorMessage(playerid, MessageText[3]);
	    if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
	    new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[128];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result)) return SendErrorMessage(playerid, "/st [상태]");
		format(string, sizeof(string), "* (상태) %s %s", PlayerNameEx(playerid), result);
		SendAroundMessage(playerid, 10.0, COLOR_STATE, COLOR_STATE, COLOR_STATE, COLOR_STATE, COLOR_STATE, string);
	    return 1;
	}
	if(strcmp(cmd, "/b", true) == 0)
	{
	    if(PlayerInfo[playerid][pChatBan] == 1) return SendErrorMessage(playerid, MessageText[3]);
	    if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[256];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result)) return SendErrorMessage(playerid, "/b [할말]");
		if(!PlayerInfo[playerid][pAdminWork])
		{
			format(string, sizeof(string), "[OOC] %s(%d): %s", PlayerNameEx(playerid), playerid, result);
			SendAroundMessage(playerid, 10.0, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, string);
		}
		return 1;
	}
	if(strcmp(cmd, "/ow", true) == 0 || strcmp(cmd, "/occpm", true) == 0)
	{
	    if(PlayerInfo[playerid][pChatBan] == 1) return SendErrorMessage(playerid, MessageText[3]);
	    if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
	    tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendErrorMessage(playerid, "/occpm [플레이어번호] [내용]");
		new giveplayerid = strval(tmp);
		if(!IsPlayerConnected(giveplayerid) && !IsPlayerLogin(giveplayerid)) return SendErrorMessage(playerid, MessageText[2]);
	    new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[128];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result)) return SendErrorMessage(playerid, "/occpm 플레이어번호 [내용]");
  		format(string, sizeof(string), "[OOC PM] %s(%d) > %s",PlayerNameEx(playerid),playerid, result);
  		SendClientMessage(giveplayerid, 0xD0D0D0FF, string);
  		format(string, sizeof(string), "[OOC PM] %s(%d) > %s",PlayerNameEx(giveplayerid),giveplayerid, result);
  		SendClientMessage(playerid, 0x9F9F9FFF, string);

  		format(string, sizeof(string), "Whisper Check : %s(%d)가 %s(%d)에게 - %s",PlayerNameEx(playerid),playerid,PlayerNameEx(giveplayerid),giveplayerid, result); printf(string);
		for(new i = 0; i < MAX_PLAYERS; i ++)
		{
		    if(IsPlayerConnected(i) && IsPlayerLogin(i))
		    	if(PlayerInfo[i][pCh_Whisper] == true)
		    	    if(PlayerInfo[i][pAdmin] >= 3) SendClientMessage(i, 0xFFFFFFFF, string);
					else PlayerInfo[i][pCh_Whisper] = false;
		}
		return 1;
	}
	if(strcmp(cmd, "/so", true) == 0 || strcmp(cmd, "/소리", true) == 0)
	{
	    if(PlayerInfo[playerid][pChatBan] == 1) return SendErrorMessage(playerid, MessageText[3]);
	    if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
	    new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[128];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result)) return SendErrorMessage(playerid, "/so [소리]");
		format(string, sizeof(string), "* %s %s", PlayerNameEx(playerid), result);
		SendAroundMessage(playerid, 10.0, COLOR_SOUND, COLOR_SOUND, COLOR_SOUND, COLOR_SOUND, COLOR_SOUND, string);
	    return 1;
	}

	if(strcmp(cmd, "/지불", true) == 0 || strcmp(cmd, "/돈지불", true) == 0)
	{
	    if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendErrorMessage(playerid, "/지불 [유저번호] [금액]");
		new giveplayerid = strval(tmp);
		if(!IsPlayerLogin(giveplayerid)) return SendErrorMessage(playerid, MessageText[2]);
		if(playerid == giveplayerid) return SendErrorMessage(playerid, MessageText[4]);
	    if(IsGivePlayerDistance(3.0, playerid, giveplayerid))
	    {
	        tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) return SendErrorMessage(playerid, "/지불 유저번호 [금액]");
			new money = strval(tmp);
			//if(money < 0 || money > 1000) return SendErrorMessage(playerid, "지불 최대 금액은 $1달러 이상 $1000달러 이하이어야 합니다.");
			if(PlayerInfo[playerid][pMoney] >= money)
			{
				format(string, sizeof(string), "당신은 %s(%d) 에게 '%d'달러를 제안했습니다.", PlayerNameEx(giveplayerid), giveplayerid, money);
				SendMessage(playerid, string);
				format(string, sizeof(string), "상대가 10초 안에 제안을 수락하지 않을 경우, 이 제안은 취소됩니다.");
				SendMessage(playerid, string);

				format(string, sizeof(string), "%s(%d)이(가) 당신에게 '%d'달러를 제안했습니다.",PlayerNameEx(playerid), playerid, money);
				SendMessage(playerid, string);
				format(string, sizeof(string), "10초 안에 /동의 지불 명령어를 사용해 제안을 수락할 수 있습니다.");
				SendMessage(playerid, string);
			}
			else return SendErrorMessage(playerid, MessageText[5]);
	    }
	    else return SendErrorMessage(playerid, MessageText[6]);
	    return 1;
	}
	
	if(strcmp(cmd, "/질문", true) == 0)
	{
	    if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
		if(NewbieChannel == true)
		{
		    new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result)) return SendErrorMessage(playerid, "/질문 [내용]");
			format(string, sizeof(string), "[질문] %s(%d): %s", PlayerNameEx(playerid), playerid, result);
			SendAllMessage(string, COLOR_QUESTION);
		}
		else return SendErrorMessage(playerid, "현재 질문 채널이 닫혀있습니다.");
	}
	
	if(strcmp(cmd, "/도움", true) == 0)
	{
	    if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
		if(NewbieChannel == true)
		{
		    new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result)) return SendErrorMessage(playerid, "/도움 [내용]");
			format(string, sizeof(string), "[도움] %s(%d): %s", PlayerNameEx(playerid), playerid, result);
			SendAllMessage(string, COLOR_ANSWER);
		}
		else return SendErrorMessage(playerid, "현재 질문 채널이 닫혀있습니다.");
	}
	
	if(strcmp(cmd, "/차", true) == 0)
	{
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
		    SendErrorMessage(playerid, "/차 [보기]");
		    SendErrorMessage(playerid, "[보기] 목록 위치");
		}
	    return 1;
	}
	//================================== admin command =================================//
	if(strcmp(cmd, "/admin", true) == 0 || strcmp(cmd, "/a", true) == 0)
	{
	    if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
	    if(PlayerInfo[playerid][pAdmin] < 1) return SendErrorMessage(playerid, MessageText[1]);
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[128];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result)) return SendErrorMessage(playerid, "/admin [대화]");
		format(string, sizeof(string), "Admin %s : "#C_WHITE"%s",PlayerInfo[playerid][pAdminName], result);
		SendAdminMessage(string, 1, 0xF361A6FF);
	    return 1;
	}
	
	if(strcmp(cmd, "/차소환", true) == 0)
	{
		if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
     	if(PlayerInfo[playerid][pAdmin] < 1) return SendErrorMessage(playerid, MessageText[1]);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendErrorMessage(playerid, "/차소환 [차번호] [색상1] [색상2]");
		new car;
		car = strval(tmp);
		if(car < 400 || car > 611) return SendErrorMessage(playerid, "차번호는 400~611까지만 가능합니다");
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendErrorMessage(playerid, "/차소환 [차번호] [색상1] [색상2]");
		new color1;
		color1 = strval(tmp);
		if(color1 < 0 || color1 > 126) return SendMessage(playerid, "색코드는 0~126까지만 가능합니다");
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendErrorMessage(playerid, "/차소환 [차번호] [색상1] [색상2]");
		new color2;
		color2 = strval(tmp);
		if(color2 < 0 || color2 > 126) return SendMessage(playerid, "색코드는 0~126까지만 가능합니다");
		new Float:X,Float:Y,Float:Z;
		GetPlayerPos(playerid, X,Y,Z);
		new carid = CreateVehicle(car, X,Y,Z, 0.0, color1, color2, 60000);
		SetVehicleHealth(carid, 10000.0);
		
		SetVehicleParamsEx(carid, true, true, false, false, false, false, false);
		
		return 1;
	}
	
	if(strcmp(cmd, "/출두", true) == 0 || strcmp(cmd, "/가", true) == 0 || strcmp(cmd, "/가자", true) == 0)
	{
	    if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
     	if(PlayerInfo[playerid][pAdmin] < 1) return SendErrorMessage(playerid, MessageText[1]);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendMessage(playerid, "/출두 [플레이어번호]");
		new giveplayerid = strval(tmp);
		if(!IsPlayerConnected(giveplayerid)) return SendErrorMessage(playerid, MessageText[2]);
		new Float:gx,Float:gy,Float:gz,interior,virtualworld,VehicleID=-1;
		interior = GetPlayerInterior(giveplayerid);
		virtualworld = GetPlayerVirtualWorld(giveplayerid);
		GetPlayerFrontPos(giveplayerid, gx, gy, gz, 1.0);
		format(string, sizeof(string), "%s님에게 텔레포트 되었습니다. [Interior : %d VirtualWorld : %d]",PlayerNameEx(giveplayerid), interior, virtualworld);
		SendMessage(playerid, string);
        if(IsPlayerInAnyVehicle(playerid))
        {
            VehicleID = GetPlayerVehicleID(playerid);
			SetVehiclePos(VehicleID, gx, gy + 5, gz);
	    }
	    else SetPlayerPosEx(playerid, gx, gy, gz, 0.0, interior, virtualworld);
		return 1;
	}
	
	if(strcmp(cmd, "/소환", true) == 0 || strcmp(cmd, "/소", true) == 0)
	{
	    if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
     	if(PlayerInfo[playerid][pAdmin] < 1) return SendErrorMessage(playerid, MessageText[1]);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return SendMessage(playerid, "/소환 [플레이어번호]");
		new giveplayerid = strval(tmp);
		if(!IsPlayerConnected(giveplayerid)) return SendErrorMessage(playerid, MessageText[2]);
		new Float:x,Float:y,Float:z,interior,virtualworld,VehicleID=-1;
		interior = GetPlayerInterior(playerid);
		virtualworld = GetPlayerVirtualWorld(playerid);
		GetPlayerFrontPos(playerid, x, y, z, 1.0);
		format(string, sizeof(string), "%s님에게 텔레포트 되었습니다. [Interior : %d VirtualWorld : %d]",PlayerNameEx(playerid), interior, virtualworld);
		SendMessage(giveplayerid, string);
        if(IsPlayerInAnyVehicle(playerid))
        {
            VehicleID = GetPlayerVehicleID(giveplayerid);
			SetVehiclePos(VehicleID, x, y + 5.0, z);
	    }
	    else return SetPlayerPosEx(giveplayerid, x, y, z, 0.0, interior, virtualworld);
	}
	
	if(strcmp(cmd, "/날씨관리", true) == 0)
	{
	    if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
		if(PlayerInfo[playerid][pAdmin] < 1) return SendErrorMessage(playerid, MessageText[1]);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			SendErrorMessage(playerid, "/날씨관리 [날씨번호]");
			return 1;
		}
		new weather;
		weather = strval(tmp);
		
		if(weather < 0 || weather > 45) return SendErrorMessage(playerid, "날씨 번호는 1 ~ 45번까지 설정 가능합니다.");
		
		SetWeatherEx(weather);
		
   		format(string, sizeof(string), "관리자 %s님이 서버의 날씨번호를 %d로 설정하였습니다.", PlayerNameEx(playerid));
		SendAdminMessage(string);
		return 1;
	}
	
	if(strcmp(cmd, "/건물관리", true) == 0)
	{
	    if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
		if(PlayerInfo[playerid][pAdmin] < 1) return SendErrorMessage(playerid, MessageText[1]);
		if(PlayerInfo[playerid][pDialogProgress][0] == 9)
		{
		    ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_LIST, "퇴장위치 관리", DialogListStyle("퇴장위치 확정\n건물생성 취소"), "확인", "취소");
		}
		else
		{
			format(string, sizeof(string), "%s", DialogListStyle("건물생성\n건물관리"));
			ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_LIST, "건물관리", string, "확인", "취소");
			PlayerInfo[playerid][pDialogProgress][0] = 1;
			PlayerInfo[playerid][pDialogProgress][1] = 1;
		}
		return 1;
	}
	
	if(strcmp(cmd, "/ATM관리", true) == 0)
	{
	    if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
		if(PlayerInfo[playerid][pAdmin] < 1) return SendErrorMessage(playerid, MessageText[1]);
		ShowPlayerDialog(playerid, DIALOG_ATM_EDIT, DIALOG_STYLE_LIST, "ATM 관리", DialogListStyle("ATM 생성\nATM 목록"), "확인", "취소");
		PlayerInfo[playerid][pDialogProgress][0] = 0;
		PlayerInfo[playerid][pDialogProgress][1] = 0;
		return 1;
	}
	
    if(strcmp(cmd, "/좌표이동", true) == 0 || strcmp(cmd, "/좌표", true) == 0)
	{
	    if(!IsPlayerLogin(playerid)) return SendErrorMessage(playerid, MessageText[0]);
	    if(PlayerInfo[playerid][pAdmin] < 1) return SendErrorMessage(playerid, MessageText[1]);
	    new Float:Pos[3], InteriorID;
	    tmp = strtok(cmdtext, idx);
	    
	    if(!strlen(tmp)) return SendErrorMessage(playerid, "/좌표이동 [PosX] [PosY] [PosZ] [Interior]");
	    Pos[0] = strval(tmp); tmp = strtok(cmdtext, idx);
	    if(!strlen(tmp)) return SendErrorMessage(playerid, "/좌표이동 PosX [PosY] [PosZ] [Interior]");
	    Pos[1] = strval(tmp); tmp = strtok(cmdtext, idx);
	    if(!strlen(tmp)) return SendErrorMessage(playerid, "/좌표이동 PosX PosY [PosZ] [Interior]");
	    Pos[2] = strval(tmp); tmp = strtok(cmdtext, idx);
	    if(!strlen(tmp)) return SendErrorMessage(playerid, "/좌표이동 PosX PosY PosZ [Interior]");
	    InteriorID = strval(tmp);
	    
	    SetPlayerPosEx(playerid, Pos[0], Pos[1], Pos[2], 0.0, InteriorID, PlayerInfo[playerid][pVirtualWorld]);
	    
	    format(string, sizeof(string), "%f,%f,%f로 이동하였습니다. InteriorID : %d",Pos[0], Pos[1], Pos[2], InteriorID);
	    SendMessage(playerid, string);
	    return 1;
	}
	else
	{
		format(string, sizeof(string), "알 수 없는 명령어 입니다. [%s]", cmdtext);
		SendClientMessage(playerid, COLOR_ERROR, string);
		return 1;
	}
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	//new var = InitComponents(componentid);
	//if(var != -1) VehicleInfo[vehicleid][vTuning][var] = componentid;
	
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == KEY_SPRINT) // 스페이스바 키
	{
	    if(PlayerInfo[playerid][pTutScreen] >= 2 && PlayerInfo[playerid][pTutScreen] != 12)
		{
		    ScreenStart(playerid, PlayerInfo[playerid][pTutScreen] + 1);
		    return 1;
		}
	}
	
	if(newkeys == KEY_JUMP) // 쉬프트 키
	{
	    if(PlayerInfo[playerid][pTutScreen] >= 3 && PlayerInfo[playerid][pTutScreen] != 12)
		{
		    ScreenStart(playerid, PlayerInfo[playerid][pTutScreen] - 1);
		    return 1;
		}
	}
	
	if(newkeys == KEY_YES) // Y 키
	{
	    if(PlayerInfo[playerid][pInventoryMode] == true)
	    {
	        InventoryMode(playerid, false);
	    }
	    else if(PlayerInfo[playerid][pInventoryMode] == false)
	    {
			InventoryMode(playerid, true);
	    }
	    return 1;
	}
	
	if(newkeys == KEY_NO) // N 키
	{
	    if(PlayerInfo[playerid][pPhoneTDChk] == true)
		{
			PhoneMode(playerid, true);
	    }
	    else if(PlayerInfo[playerid][pPhoneTDChk] == false)
		{
			PhoneMode(playerid, true);
	    }
	    return 1;
	}
	
	if(newkeys == KEY_SECONDARY_ATTACK) // F 키 or Enter 키
	{
	    if(IsPlayerInRangeOfPoint(playerid, 2.0, 1674.1240,-1253.9209,14.9799)) // 계좌 개설
	    {
	        if(IsItemHaveState(playerid, 2004) == 0)
			{
				new string[550];
				format(string, sizeof(string), ""#C_GRAY"_____________________________계좌 개설_____________________________"#C_WHITE"\n\n\
												이곳에서 Bank of America 은행의 당좌 예금 계좌를 개설할 수 있습니다. 계좌를 개설\n\
												하면 앞으로 사용하게 될 새로운 통장과 Debit 카드를 발급받을 수 있습니다. Debit 카\n");
				format(string, sizeof(string), "%s드를 발급받으면 산 안드레스 주 어디에서든 은행과 ATM 서비스를 이용할 수 있으며,\n\
												물건을 구매할 때 현금 대신 결제 수단으로 사용할 수 있습니다. 핸드폰의 은행 앱을 이\n\
												용하면 입,출금을 제외한 모든 서비스를 더 쉽게 이용할 수 있습니다.\n\n\
												계좌 개설 비용 : %d $", string, BANK_CRE_PRICE);
				ShowPlayerDialog(playerid, DIALOG_BANK_CRE, DIALOG_STYLE_MSGBOX, "당좌 예금 계좌 개설", string, "계설신청", "취소");

				PlayerInfo[playerid][pDialogProgress][0] = 0;
			}
			else SendErrorMessage(playerid, "이미 보통예금이 있습니다.");
			return 1;
	    }
	    else if(IsPlayerInRangeOfPoint(playerid, 1.0, 1679.6182,-1253.9209,14.9799)) // 계좌 관리
	    {
	        if(IsItemHaveState(playerid, 2004) == 0)
		    {
		        SendErrorMessage(playerid, "당신은 보통예금 계좌가 없습니다.");
		        return 1;
		    }
	        PlayerInfo[playerid][pDialogProgress][0] = 0;
	        PlayerInfo[playerid][pDialogProgress][1] = 0;
	        PlayerInfo[playerid][pDialogProgress][2] = 0;
	        PlayerInfo[playerid][pDialogProgress][3] = 0;
	    
	        ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_LIST, "계좌 관리 창구", DialogListStyle("계좌 정보 조회\n입금\n출금\n송금"), "확인", "취소");
	        return 1;
	    }
	    else if(IsPlayerInRangeOfPoint(playerid, 1.0, 1293.7079,-1330.1460,13.5530)) // 차량구매
	    {
	        ShowPlayerDialog(playerid, DIALOG_VEHICLE_SHOP, DIALOG_STYLE_LIST, "차량구매", DialogListStyle("차량구매\n차량튜닝"), "확인", "취소");
	    }
	    else
	    {
	        for(new i = 0; i < MAX_ATM; i ++)
			{
			    if(ATMInfo[i][atm_create] == 1)
			    {
			        if(IsPlayerInRangeOfPoint(playerid, 0.5, ATMInfo[i][atm_pickupPos][0], ATMInfo[i][atm_pickupPos][1], ATMInfo[i][atm_pickupPos][2])) // ATM F키
				    {
				        PlayerInfo[playerid][pDialogProgress][0] = 0;
				        PlayerInfo[playerid][pDialogProgress][1] = 0;
				        PlayerInfo[playerid][pDialogProgress][2] = 0;
				        PlayerInfo[playerid][pDialogProgress][3] = 0;

				        ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_LIST, "계좌 관리 창구", DialogListStyle("계좌 정보 조회\n입금\n출금\n송금"), "확인", "취소");
				        return 1;
				    }
				}
	        }
	        
		    for(new b = 0; b < MAX_BUILD; b ++)
			{
			    if(BuildInfo[b][bCreate] == 1)
			    {
			        if(IsPlayerInRangeOfPoint(playerid, 1.0, BuildInfo[b][bInPos][0], BuildInfo[b][bInPos][1], BuildInfo[b][bInPos][2]))
			        {
			            //new Float:distance = GetPlayerDistanceFromPoint(playerid, BuildInfo[b][bOutPos][0], BuildInfo[b][bOutPos][1], BuildInfo[b][bOutPos][2]);
			            if(BuildInfo[b][bInInterior] != BuildInfo[b][bOutInterior] || BuildInfo[b][bInVirtualWorld] != BuildInfo[b][bOutVirtualWorld])
			            {
			                EnterEvent(playerid);
			                TogglePlayerControllable(playerid, false);
			                SetPlayerPosEx(playerid, BuildInfo[b][bOutPos][0], BuildInfo[b][bOutPos][1], BuildInfo[b][bOutPos][2], 0.0, BuildInfo[b][bOutInterior], BuildInfo[b][bOutVirtualWorld]);
			            }
			            else SetPlayerPosEx(playerid, BuildInfo[b][bOutPos][0], BuildInfo[b][bOutPos][1], BuildInfo[b][bOutPos][2], 0.0, BuildInfo[b][bOutInterior], BuildInfo[b][bOutVirtualWorld]);
			            return 1;
			        }
					else if(IsPlayerInRangeOfPoint(playerid, 1.0, BuildInfo[b][bOutPos][0], BuildInfo[b][bOutPos][1], BuildInfo[b][bOutPos][2]))
					{
					    if(BuildInfo[b][bOutInterior] != BuildInfo[b][bInInterior] || BuildInfo[b][bOutVirtualWorld] != BuildInfo[b][bInVirtualWorld])
			            {
			                EnterEvent(playerid);
			                TogglePlayerControllable(playerid, false);
			                SetPlayerPosEx(playerid, BuildInfo[b][bInPos][0], BuildInfo[b][bInPos][1], BuildInfo[b][bInPos][2], 0.0, BuildInfo[b][bInInterior], BuildInfo[b][bInVirtualWorld]);
			            }
			            else SetPlayerPosEx(playerid, BuildInfo[b][bInPos][0], BuildInfo[b][bInPos][1], BuildInfo[b][bInPos][2], 0.0, BuildInfo[b][bInInterior], BuildInfo[b][bInVirtualWorld]);
			            return 1;
					}
			    }
			}
		}
	}
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
		case DIALOG_REGISTER:
		{
		    if(response)
		    {
		        if(PlayerInfo[playerid][pRegState] == 1)
		        {
			        if(strlen(inputtext) >= 4 && strlen(inputtext) <= 12)
			        {
			            SendMessage(playerid, "비밀번호를 재입력 해주세요.");
			            strmid(PlayerInfo[playerid][pTmpPwd], inputtext, 0, 128, 128);
						RegDialogue(playerid, 2);
			        }
			        else
			        {
			            SendErrorMessage(playerid, "비밀번호는 네자 이상 12자 이하이어야 합니다.");
			            RegDialogue(playerid, 1);
			        }
				}
				else if(PlayerInfo[playerid][pRegState] == 2)
				{
				    if(strcmp(PlayerInfo[playerid][pTmpPwd], inputtext, false) == 0)
				    {
					    new password[128];
					    SHA512(inputtext, password, 128);
						strmid(PlayerInfo[playerid][pPassword], password, 0, 128, 128);
						orm_save(PlayerInfo[playerid][ORM_ID], "OnPlayerLogin", "d", playerid);
					}
					else
					{
					    SendErrorMessage(playerid, "비밀번호가 맞지 않습니다. 처음부터 다시 작성해주세요.");
					    RegDialogue(playerid, 1);
					}
				}
		    }
		    else
			{
			    if(PlayerInfo[playerid][pRegState] == 1) KickEx(playerid, 1);
			    else if(PlayerInfo[playerid][pRegState] == 2) RegDialogue(playerid, 1);
			}
		}
		case DIALOG_LOGIN:
		{
		    if(response)
		    {
		        if(!strlen(inputtext)) return LogDialogue(playerid);
	            new query[256], password[128], string[128];
			    SHA512(inputtext, password, 128);
				strmid(password, password, 0, 128, 128);
				mysql_format(MySQL, query, sizeof(query),"SELECT * FROM `%s` WHERE `pName` = '%s' AND `pPassword` = '%s' LIMIT 1", MySQL_USER, PlayerNameEx(playerid), password);
				new Cache:result = mysql_query(MySQL, query, true);
				new MySQLDataBaseRow = cache_num_rows();
				if(MySQLDataBaseRow > 0) orm_save(PlayerInfo[playerid][ORM_ID], "OnPlayerLogin", "d", playerid);
				else
				{
				    PlayerInfo[playerid][pPasswordCheck]++;
				    if(PlayerInfo[playerid][pPasswordCheck] >= 5)
				    {
				        format(string, sizeof(string), "비밀번호가 일치하지 않습니다. [%d/5]", PlayerInfo[playerid][pPasswordCheck]);
				    	SendErrorMessage(playerid, string);
				    	KickEx(playerid, 1);
				        return 1;
				    }
				    LogDialogue(playerid);
				    format(string, sizeof(string), "비밀번호가 일치하지 않습니다. [%d/5]", PlayerInfo[playerid][pPasswordCheck]);
				    SendErrorMessage(playerid, string);
				}
				cache_delete(result);
		    }
		    else return KickEx(playerid, 1);
		}
		case DIALOG_CONTINENT:
		{
		    if(response)
		    {
		        new string[256];
		        new continent = listitem + 1, index = 0, strNumber[5];
				new str[52]; 
		        for(new i = 0; i < MAX_COUNTRY; i ++)
		        {
		            format(strNumber, sizeof(strNumber), "%d", CountryInfo[i][0]);
		            if(strval(strNumber) == continent)
		            {
						format(strNumber, sizeof(strNumber), "%d", CountryInfo[i][2]);
		                PlayerInfo[playerid][pContinent][index] = strval(strNumber);
		                if(!strlen(string))
						{
							format(string, sizeof(string), "%s", CountryInfo[i][3]);
							strmid(str, CountryInfo[i][1], 0, 52, 52);
				        }
		                else format(string, sizeof(string), "%s\n%s", string, CountryInfo[i][3]);
		                index++;
		            }
		        }
		        ShowPlayerDialog(playerid, DIALOG_COUNTRY, DIALOG_STYLE_LIST, str, string, "확인", "이전");
		    }
		    else
		    {
		    }
		    return 1;
		}
		case DIALOG_COUNTRY:
		{
		    if(response)
		    {
		        new string[52];
		        PlayerInfo[playerid][pCountry] = PlayerInfo[playerid][pContinent][listitem] ;
		        format(string, sizeof(string), "%s", CountryInfo[PlayerInfo[playerid][pCountry] - 1][4]);
				TextDrawSetString(RegInfoTD[playerid][12], string);
				TextDrawHideForPlayer(playerid, RegInfoTD[playerid][12]);
				TextDrawShowForPlayer(playerid, RegInfoTD[playerid][12]);
		    }
		    else return ShowContinent(playerid);
		    return 1;
		}
		case DIALOG_BUILD_EDIT:
		{
		    if(response)
		    {
		        if(PlayerInfo[playerid][pDialogProgress][0] == 4)
	            {
					PlayerInfo[playerid][pDialogBuildIndex] = PlayerInfo[playerid][pDialogBuildNum][listitem];
                    PlayerInfo[playerid][pDialogProgress][0] = 5;
                    
                    ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "집 생성", ""#C_WHITE"원하시는 이 건물의 이름을 정해주세요.", "확인", "이전");
	            }
	            else if(PlayerInfo[playerid][pDialogProgress][0] == 5)
	            {
	                if(strlen(inputtext))
	                {
	                    new index = PlayerInfo[playerid][pDialogBuildIndex];
	                    new interior = GetPlayerInterior(playerid), virtualworld = GetPlayerVirtualWorld(playerid);
	                    new string[128];
	            
		                new Float:pos[3]; GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
					    if(BuildDataGenerate(pos[0], pos[1], pos[2], InteriorInfo[index][iPosX], InteriorInfo[index][iPosY], InteriorInfo[index][iPosZ],
						inputtext, interior, InteriorInfo[index][iInterior], virtualworld, _, 1) == 1)
						{
						    format(string, sizeof(string), "어드민 %s님이 집을 생성하였습니다. [%s]", PlayerInfo[playerid][pAdminName], inputtext);
							SendAdminMessage(string);
				        }
				        else SendErrorMessage(playerid, "더 이상 건물을 생성할 수 없습니다.");

					    for(new i = 0; i < 10; i ++)
						    PlayerInfo[playerid][pDialogProgress][i] = 0;
					}
					else
					{
	                    PlayerInfo[playerid][pDialogProgress][0] = 5;

	                    ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "집 생성", ""#C_WHITE"원하시는 이 건물의 이름을 정해주세요.", "확인", "이전");
					}
	            }
	            else if(PlayerInfo[playerid][pDialogProgress][0] == 6)
	            {
	                PlayerInfo[playerid][pDialogBuildIndex] = PlayerInfo[playerid][pDialogBuildNum][listitem];
                    PlayerInfo[playerid][pDialogProgress][0] = 7;

                    ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "사업장 생성", ""#C_WHITE"원하시는 이 건물의 이름을 정해주세요.", "확인", "이전");
	            }
	            else if(PlayerInfo[playerid][pDialogProgress][0] == 7)
	            {
	                if(strlen(inputtext))
	                {
	                    new index = PlayerInfo[playerid][pDialogBuildIndex];
	                    new interior = GetPlayerInterior(playerid), virtualworld = GetPlayerVirtualWorld(playerid);
	                    new string[128];

		                new Float:pos[3]; GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
					    if(BuildDataGenerate(pos[0], pos[1], pos[2], InteriorInfo[index][iPosX], InteriorInfo[index][iPosY], InteriorInfo[index][iPosZ],
						inputtext, interior, InteriorInfo[index][iInterior], virtualworld, _, 2) == 1)
						{
						    format(string, sizeof(string), "어드민 %s님이 사업장을 생성하였습니다. [%s]", PlayerInfo[playerid][pAdminName], inputtext);
							SendAdminMessage(string);
				        }
				        else SendErrorMessage(playerid, "더 이상 건물을 생성할 수 없습니다.");

					    for(new i = 0; i < 10; i ++)
						    PlayerInfo[playerid][pDialogProgress][i] = 0;
					}
					else
					{
	                    PlayerInfo[playerid][pDialogProgress][0] = 8;

                    	ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "사업장 생성", ""#C_WHITE"원하시는 이 건물의 이름을 정해주세요.", "확인", "이전");
					}
	            }
	            else if(PlayerInfo[playerid][pDialogProgress][0] == 9)
	            {
	                if(listitem == 0) // 퇴장 위치 확정
	                {
						new Float:pos[3], interior, virtualworld;
						
	                    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
					    virtualworld = GetPlayerVirtualWorld(playerid);
					    interior = GetPlayerInterior(playerid);
					    
					    PlayerInfo[playerid][pBuildOutPos][0] = pos[0];
					    PlayerInfo[playerid][pBuildOutPos][1] = pos[1];
					    PlayerInfo[playerid][pBuildOutPos][2] = pos[2];
					    PlayerInfo[playerid][pBuildOutInterior] = interior;
					    PlayerInfo[playerid][pBuildOutVirtualWorld] = virtualworld;
					    PlayerInfo[playerid][pDialogProgress][0] = 10;
					    
					    new string[300];
						format(string, sizeof(string), ""#C_GRAY"\t- 건물생성 -\n\n"#C_WHITE"입장좌표 : %.4f,%.4f,%.4f\n퇴장좌표 : %.4f,%.4f,%.4f\n\n\
														입장 인테리어 : %d\n퇴장 인테리어 : %d\n\n입장 가상세계 : %d\n퇴장 가상세계 : %d\n\n\
														입장/퇴장 기능을 확정하시려면 이 객체의 이름을 설정해주세요.",
														PlayerInfo[playerid][pBuildInPos][0], PlayerInfo[playerid][pBuildInPos][1], PlayerInfo[playerid][pBuildInPos][2],
														PlayerInfo[playerid][pBuildOutPos][0], PlayerInfo[playerid][pBuildOutPos][1], PlayerInfo[playerid][pBuildOutPos][2],
														PlayerInfo[playerid][pBuildInInterior], PlayerInfo[playerid][pBuildOutInterior],
														PlayerInfo[playerid][pBuildInVirtualWorld], PlayerInfo[playerid][pBuildOutVirtualWorld]);
					    ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "입장퇴장 생성", string, "생성", "이전");
	                }
					if(listitem == 1) // 입장/퇴장 건물관리 취소
	                {
	                    SendMessage(playerid, "입장/퇴장 생성이 취소 되었습니다.");
	                
	                    PlayerInfo[playerid][pDialogProgress][0] = 0;
	                    PlayerInfo[playerid][pDialogProgress][1] = 0;
	                }
	            }
	            else if(PlayerInfo[playerid][pDialogProgress][0] == 10)
	            {
	                if(strlen(inputtext))
	                {
	                    PlayerInfo[playerid][pDialogProgress][0] = 0;
	                    
	                    if(BuildDataGenerate(PlayerInfo[playerid][pBuildInPos][0], PlayerInfo[playerid][pBuildInPos][1], PlayerInfo[playerid][pBuildInPos][2], PlayerInfo[playerid][pBuildOutPos][0], PlayerInfo[playerid][pBuildOutPos][1], PlayerInfo[playerid][pBuildOutPos][2],
						inputtext, PlayerInfo[playerid][pBuildInInterior], PlayerInfo[playerid][pBuildOutInterior], PlayerInfo[playerid][pBuildInVirtualWorld], PlayerInfo[playerid][pBuildOutVirtualWorld], 0) == 1)
						{
						    new string[128];
						    format(string, sizeof(string), "어드민 %s님이 입장/퇴장 객체를 생성하셨습니다. [%s]", PlayerInfo[playerid][pAdminName], inputtext);
							SendAdminMessage(string);
				        }
				        else SendErrorMessage(playerid, "더 이상 입장/퇴장을 생성할 수 없습니다.");
	                }
	                else
	                {
	                    new string[300];
						format(string, sizeof(string), ""#C_GRAY"\t- 건물생성 -\n\n"#C_WHITE"입장좌표 : %.4f,%.4f,%.4f\n퇴장좌표 : %.4f,%.4f,%.4f\n\n\
														입장 인테리어 : %d\n퇴장 인테리어 : %d\n\n입장 가상세계 : %d\n퇴장 가상세계 : %d\n\n\
														입장/퇴장 기능을 확정하시려면 이 객체의 이름을 설정해주세요.",
														PlayerInfo[playerid][pBuildInPos][0], PlayerInfo[playerid][pBuildInPos][1], PlayerInfo[playerid][pBuildInPos][2],
														PlayerInfo[playerid][pBuildOutPos][0], PlayerInfo[playerid][pBuildOutPos][1], PlayerInfo[playerid][pBuildOutPos][2],
														PlayerInfo[playerid][pBuildInInterior], PlayerInfo[playerid][pBuildOutInterior],
														PlayerInfo[playerid][pBuildInVirtualWorld], PlayerInfo[playerid][pBuildOutVirtualWorld]);
					    ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "입장퇴장 생성", string, "생성", "이전");
					    
					    SendErrorMessage(playerid, "다시 작성해주세요.");
					    
					    PlayerInfo[playerid][pDialogProgress][0] = 10;
	                }
	            }
				else if(PlayerInfo[playerid][pDialogProgress][1] == 2)
				{
				    PlayerInfo[playerid][pDialogProgress][1] = 3;
				    PlayerInfo[playerid][pTempBuildIndex] = PlayerInfo[playerid][pTempBuildIndexs][listitem];

					ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_LIST, "건물관리", DialogListStyle("건물이름 변경\n입장위치 변경\n퇴장위치 변경\n입장 픽업 인테리어 번호 변경\n입장 픽업 가상세계 번호 변경\n퇴장 픽업 인테리어 번호 변경\n퇴장 픽업 가상세계 번호 변경"), "확인", "이전");
				}
				else if(PlayerInfo[playerid][pDialogProgress][1] == 3)
			    {
			        if(listitem == 0)
			        {
			            PlayerInfo[playerid][pDialogProgress][1] = 4;
			            ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "건물이름 변경", ""#C_WHITE"변경하실 건물의 이름을 입력해주세요.", "확인", "이전");
			        }
			        if(listitem == 1)
			        {
                        if(BuildInfo[PlayerInfo[playerid][pTempBuildIndex]][bType] == 0)
                        {
                            PlayerInfo[playerid][pDialogProgress][1] = 5;
                            ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "건물 입장위치 변경", ""#C_WHITE"변경하실 건물의 입장 위치 좌표를 입력해주세요.", "확인", "이전");
                        }
			            else
			            {
			                PlayerInfo[playerid][pDialogProgress][0] = 0;
			                PlayerInfo[playerid][pDialogProgress][1] = 0;

			                SendErrorMessage(playerid, "입장/퇴장 타입의 픽업만 위치를 바꿀 수 있습니다.");
			            }
			        }
			        if(listitem == 2)
			        {
			            if(BuildInfo[PlayerInfo[playerid][pTempBuildIndex]][bType] == 0)
                        {
			            	PlayerInfo[playerid][pDialogProgress][1] = 6;
			            	ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "건물 퇴장위치 변경", ""#C_WHITE"변경하실 건물의 퇴장 위치 좌표를 입력해주세요.", "확인", "이전");
			            }
			            else
						{
				            PlayerInfo[playerid][pDialogProgress][0] = 0;
				            PlayerInfo[playerid][pDialogProgress][1] = 0;

				            SendErrorMessage(playerid, "입장/퇴장 타입의 픽업만 위치를 바꿀 수 있습니다.");
				        }
			        }
			        if(listitem == 3)
			        {
			            if(BuildInfo[PlayerInfo[playerid][pTempBuildIndex]][bType] == 0)
                        {
			            	PlayerInfo[playerid][pDialogProgress][1] = 7;
			            	ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "입장 픽업 인테리어 번호 변경", ""#C_WHITE"변경하실 건물의 입장 픽업 인테리어 번호를 입력해주세요.", "확인", "이전");
			            }
			            else
						{
				            PlayerInfo[playerid][pDialogProgress][0] = 0;
				            PlayerInfo[playerid][pDialogProgress][1] = 0;

				            SendErrorMessage(playerid, "입장/퇴장 타입의 픽업만 인테리어 번호를 바꿀 수 있습니다.");
				        }
			        }
			        if(listitem == 4)
			        {
			            if(BuildInfo[PlayerInfo[playerid][pTempBuildIndex]][bType] == 0)
                        {
			            	PlayerInfo[playerid][pDialogProgress][1] = 8;
			            	ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "입장 픽업 가상세계 번호 변경", ""#C_WHITE"변경하실 건물의 입장 픽업 가상세계 번호를 입력해주세요.", "확인", "이전");
			            }
			            else
						{
				            PlayerInfo[playerid][pDialogProgress][0] = 0;
				            PlayerInfo[playerid][pDialogProgress][1] = 0;

				            SendErrorMessage(playerid, "입장/퇴장 타입의 픽업만 가상세계 번호를 바꿀 수 있습니다.");
				        }
			        }
			        if(listitem == 5)
			        {
			            if(BuildInfo[PlayerInfo[playerid][pTempBuildIndex]][bType] == 0)
                        {
			            	PlayerInfo[playerid][pDialogProgress][1] = 9;
			            	ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "퇴장 픽업 인테리어 번호 변경", ""#C_WHITE"변경하실 건물의 퇴장 픽업 인테리어 번호를 입력해주세요.", "확인", "이전");
			            }
			            else
						{
				            PlayerInfo[playerid][pDialogProgress][0] = 0;
				            PlayerInfo[playerid][pDialogProgress][1] = 0;

				            SendErrorMessage(playerid, "입장/퇴장 타입의 픽업만 인테리어 번호를 바꿀 수 있습니다.");
				        }
			        }
			        if(listitem == 6)
			        {
			            if(BuildInfo[PlayerInfo[playerid][pTempBuildIndex]][bType] == 0)
                        {
			            	PlayerInfo[playerid][pDialogProgress][1] = 10;
			            	ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "퇴장 픽업 가상세계 번호 변경", ""#C_WHITE"변경하실 건물의 퇴장 픽업 가상세계 번호를 입력해주세요.", "확인", "이전");
			            }
			            else
						{
				            PlayerInfo[playerid][pDialogProgress][0] = 0;
				            PlayerInfo[playerid][pDialogProgress][1] = 0;

				            SendErrorMessage(playerid, "입장/퇴장 타입의 픽업만 가상세계 번호를 바꿀 수 있습니다.");
				        }
			        }
			    }
			    else if(PlayerInfo[playerid][pDialogProgress][1] == 4)
			    {
					if(strlen(inputtext))
					{
					    new index = PlayerInfo[playerid][pTempBuildIndex];

					    PlayerInfo[playerid][pDialogProgress][0] = 0;
						PlayerInfo[playerid][pDialogProgress][1] = 0;

					    if(BuildInfo[index][bCreate] == 1)
					    {
						    strmid(BuildInfo[index][bCreate], inputtext, 0, 128, 128);
							Update3DTextLabelText(BuildInfo[index][bInTextLabelID], COLOR_BUILD, buildLabelStyle(BuildInfo[index][bNumber]));
						    BuildDataSave(BuildInfo[index][bNumber]);

			            }
			            else
			            {
			                SendErrorMessage(playerid, "존재하지 않는 건물입니다.");
			            }
					}
					else
					{
					    PlayerInfo[playerid][pDialogProgress][1] = 4;
			            ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "건물이름 변경", ""#C_WHITE"변경하실 건물의 이름을 입력해주세요.", "확인", "이전");

			            SendErrorMessage(playerid, "다시 입력해주세요.");
					}
			    }
			    else if(PlayerInfo[playerid][pDialogProgress][1] == 5)
			    {
			        if(BuildInfo[PlayerInfo[playerid][pTempBuildIndex]][bType] != 0)
			        {
			            PlayerInfo[playerid][pDialogProgress][0] = 0;
						PlayerInfo[playerid][pDialogProgress][1] = 0;
						
						SendErrorMessage(playerid, "입장/퇴장 타입의 픽업만 변경할 수 있습니다.");
						return 1;
			        }
			        if(strlen(inputtext))
					{
					    if(BuildInfo[PlayerInfo[playerid][pTempBuildIndex]][bCreate] == 1)
					    {
					        new coordinate[3][15];
					        
						    new string[128];
							strmid(string, inputtext, 0, 128, 128);

							new number = 0, number2 = 0;
							new length = strlen(string);

							for(new i = 0; i < length; i ++)
							{
							    if(string[i] == ' ') number ++;
							    if(string[i] == ',') number2 ++;
							}
							if(number == 3 || number2 == 3)
						    {
              					new index = PlayerInfo[playerid][pTempBuildIndex];

						        PlayerInfo[playerid][pDialogProgress][0] = 0;
								PlayerInfo[playerid][pDialogProgress][1] = 0;


						    	if(number == 3) split(string, coordinate, ' ');
							    else if(number2 == 3) split(string, coordinate, ',');

								BuildInfo[index][bInPos][0] = floatstr(coordinate[0]); BuildInfo[index][bInPos][1] = floatstr(coordinate[1]); BuildInfo[index][bInPos][2] = floatstr(coordinate[2]);
								if(BuildInfo[index][bInPickup] > -1) DestroyPickup(BuildInfo[index][bInPickup]);
								BuildInfo[index][bInPickup] = CreatePickup(1239, 1, BuildInfo[index][bInPos][0], BuildInfo[index][bInPos][1], BuildInfo[index][bInPos][2], BuildInfo[index][bInVirtualWorld]);
								if(BuildInfo[index][bInTextLabelID] > Text3D:-1) Delete3DTextLabel(BuildInfo[index][bInTextLabelID]);
								BuildInfo[index][bInTextLabelID] 	= Create3DTextLabel(buildLabelStyle(BuildInfo[index][bNumber]), COLOR_BUILD, BuildInfo[index][bInPos][0], BuildInfo[index][bInPos][1], BuildInfo[index][bInPos][2], 10.0, BuildInfo[index][bInVirtualWorld]);
								BuildDataSave(BuildInfo[index][bNumber]);
						    }
						    else
						    {
						        PlayerInfo[playerid][pDialogProgress][1] = 5;
		                        ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "건물 입장위치 변경", ""#C_WHITE"변경하실 건물의 입장 위치 좌표를 입력해주세요.", "확인", "이전");

		                        SendErrorMessage(playerid, "다시 입력해주세요.");
						    }
      					}
						else
			            {
			                PlayerInfo[playerid][pDialogProgress][0] = 0;
							PlayerInfo[playerid][pDialogProgress][1] = 0;

			                SendErrorMessage(playerid, "존재하지 않는 건물입니다.");
			            }
					}
					else
					{
					    PlayerInfo[playerid][pDialogProgress][1] = 5;
                        ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "건물 입장위치 변경", ""#C_WHITE"변경하실 건물의 입장 위치 좌표를 입력해주세요.", "확인", "이전");
                        
                        SendErrorMessage(playerid, "다시 입력해주세요.");
					}
			    }
			    else if(PlayerInfo[playerid][pDialogProgress][1] == 6)
			    {
			        if(BuildInfo[PlayerInfo[playerid][pTempBuildIndex]][bType] != 0)
			        {
			            PlayerInfo[playerid][pDialogProgress][0] = 0;
						PlayerInfo[playerid][pDialogProgress][1] = 0;

						SendErrorMessage(playerid, "입장/퇴장 타입의 픽업만 변경할 수 있습니다.");
						return 1;
			        }
			        if(strlen(inputtext))
					{
					    if(BuildInfo[PlayerInfo[playerid][pTempBuildIndex]][bCreate] == 1)
					    {
					        // new coordinate[3][15];
					        
						    new string[128];
							strmid(string, inputtext, 0, 128, 128);

							new number = 0, number2 = 0;
							new length = strlen(string);

							for(new i = 0; i < length; i ++)
							{
							    if(string[i] == ' ') number ++;
							    if(string[i] == ',') number2 ++;
							}
							if(number == 3 || number2 == 3)
						    {
              					new index = PlayerInfo[playerid][pTempBuildIndex];

						        PlayerInfo[playerid][pDialogProgress][0] = 0;
								PlayerInfo[playerid][pDialogProgress][1] = 0;

							    if(number == 3) split(string, coordinate, ' ');
							    else if(number2 == 3) split(string, coordinate, ',');

								BuildInfo[index][bOutPos][0] = floatstr(coordinate[0]); BuildInfo[index][bOutPos][1] = floatstr(coordinate[1]); BuildInfo[index][bOutPos][2] = floatstr(coordinate[2]);
								if(BuildInfo[index][bOutPickup] > 0) DestroyPickup(BuildInfo[index][bOutPickup]);
								BuildInfo[index][bOutPickup] = CreatePickup(1239, 1, BuildInfo[index][bOutPos][0], BuildInfo[index][bOutPos][1], BuildInfo[index][bOutPos][2], BuildInfo[index][bOutVirtualWorld]);
								BuildDataSave(BuildInfo[index][bNumber]);
						    }
						    else
						    {
              					PlayerInfo[playerid][pDialogProgress][1] = 5;
		                        ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "건물 입장위치 변경", ""#C_WHITE"변경하실 건물의 입장 위치 좌표를 입력해주세요.", "확인", "이전");

		                        SendErrorMessage(playerid, "다시 입력해주세요.");
						    }
						}
						else
			            {
			                PlayerInfo[playerid][pDialogProgress][0] = 0;
							PlayerInfo[playerid][pDialogProgress][1] = 0;

			                SendErrorMessage(playerid, "존재하지 않는 건물입니다.");
			            }
					}
					else
					{
					    PlayerInfo[playerid][pDialogProgress][1] = 5;
                        ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "건물 입장위치 변경", ""#C_WHITE"변경하실 건물의 입장 위치 좌표를 입력해주세요.", "확인", "이전");

                        SendErrorMessage(playerid, "다시 입력해주세요.");
					}
			    }
			    else if(PlayerInfo[playerid][pDialogProgress][1] == 7)
			    {
			        if(BuildInfo[PlayerInfo[playerid][pTempBuildIndex]][bType] != 0)
			        {
			            PlayerInfo[playerid][pDialogProgress][0] = 0;
						PlayerInfo[playerid][pDialogProgress][1] = 0;

						SendErrorMessage(playerid, "입장/퇴장 타입의 픽업만 변경할 수 있습니다.");
						return 1;
			        }
			        if(strlen(inputtext))
					{
					    if(BuildInfo[PlayerInfo[playerid][pTempBuildIndex]][bCreate] == 1)
					    {
						    new index 	 = PlayerInfo[playerid][pTempBuildIndex],
 					        	interior = strval(inputtext);
						    if(0 <= interior < 255)
						    {
						        PlayerInfo[playerid][pDialogProgress][0] = 0;
								PlayerInfo[playerid][pDialogProgress][1] = 0;
						    
							    BuildInfo[index][bInInterior] = interior;
							    BuildDataSave(BuildInfo[index][bNumber]);
							}
							else
							{
								PlayerInfo[playerid][pDialogProgress][1] = 7;
					            ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "입장 픽업 인테리어 번호 변경", ""#C_WHITE"변경하실 건물의 입장 픽업 인테리어 번호를 입력해주세요.", "확인", "이전");

		                        SendErrorMessage(playerid, "다시 입력해주세요.");
							}
						}
						else
			            {
			                PlayerInfo[playerid][pDialogProgress][0] = 0;
							PlayerInfo[playerid][pDialogProgress][1] = 0;

			                SendErrorMessage(playerid, "존재하지 않는 건물입니다.");
			            }
					}
					else
					{
					    PlayerInfo[playerid][pDialogProgress][1] = 7;
			            ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "입장 픽업 인테리어 번호 변경", ""#C_WHITE"변경하실 건물의 입장 픽업 인테리어 번호를 입력해주세요.", "확인", "이전");

                        SendErrorMessage(playerid, "다시 입력해주세요.");
					}
			    }
			    else if(PlayerInfo[playerid][pDialogProgress][1] == 8)
			    {
			        if(BuildInfo[PlayerInfo[playerid][pTempBuildIndex]][bType] != 0)
			        {
			            PlayerInfo[playerid][pDialogProgress][0] = 0;
						PlayerInfo[playerid][pDialogProgress][1] = 0;

						SendErrorMessage(playerid, "입장/퇴장 타입의 픽업만 변경할 수 있습니다.");
						return 1;
			        }
			        if(strlen(inputtext))
					{
					    if(BuildInfo[PlayerInfo[playerid][pTempBuildIndex]][bCreate] == 1)
					    {
						    new index 	 = PlayerInfo[playerid][pTempBuildIndex],
 					        	virtualworld = strval(inputtext);
						    if(0 <= virtualworld < 2147483647)
						    {
						        PlayerInfo[playerid][pDialogProgress][0] = 0;
								PlayerInfo[playerid][pDialogProgress][1] = 0;

							    BuildInfo[index][bInVirtualWorld] = virtualworld;
							    BuildDataSave(BuildInfo[index][bNumber]);
							}
							else
							{
								PlayerInfo[playerid][pDialogProgress][1] = 8;
					            ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "입장 픽업 가상세계 번호 변경", ""#C_WHITE"변경하실 건물의 입장 픽업 가상세계 번호를 입력해주세요.", "확인", "이전");

		                        SendErrorMessage(playerid, "다시 입력해주세요.");
							}
						}
						else
			            {
			                PlayerInfo[playerid][pDialogProgress][0] = 0;
							PlayerInfo[playerid][pDialogProgress][1] = 0;

			                SendErrorMessage(playerid, "존재하지 않는 건물입니다.");
			            }
					}
					else
					{
					    PlayerInfo[playerid][pDialogProgress][1] = 8;
			            ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "입장 픽업 가상세계 번호 변경", ""#C_WHITE"변경하실 건물의 입장 픽업 가상세계 번호를 입력해주세요.", "확인", "이전");

                        SendErrorMessage(playerid, "다시 입력해주세요.");
					}
			    }
			    else if(PlayerInfo[playerid][pDialogProgress][1] == 9)
			    {
			        if(BuildInfo[PlayerInfo[playerid][pTempBuildIndex]][bType] != 0)
			        {
			            PlayerInfo[playerid][pDialogProgress][0] = 0;
						PlayerInfo[playerid][pDialogProgress][1] = 0;

						SendErrorMessage(playerid, "입장/퇴장 타입의 픽업만 변경할 수 있습니다.");
						return 1;
			        }
			        if(strlen(inputtext))
					{
					    if(BuildInfo[PlayerInfo[playerid][pTempBuildIndex]][bCreate] == 1)
					    {
						    new index 	 = PlayerInfo[playerid][pTempBuildIndex],
 					        	interior = strval(inputtext);
						    if(0 <= interior < 255)
						    {
						        PlayerInfo[playerid][pDialogProgress][0] = 0;
								PlayerInfo[playerid][pDialogProgress][1] = 0;

							    BuildInfo[index][bOutInterior] = interior;
							    BuildDataSave(BuildInfo[index][bNumber]);
							}
							else
							{
								PlayerInfo[playerid][pDialogProgress][1] = 9;
					            ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "퇴장 픽업 인테리어 번호 변경", ""#C_WHITE"변경하실 건물의 퇴장 픽업 인테리어 번호를 입력해주세요.", "확인", "이전");

		                        SendErrorMessage(playerid, "다시 입력해주세요.");
							}
						}
						else
			            {
			                PlayerInfo[playerid][pDialogProgress][0] = 0;
							PlayerInfo[playerid][pDialogProgress][1] = 0;

			                SendErrorMessage(playerid, "존재하지 않는 건물입니다.");
			            }
					}
					else
					{
					    PlayerInfo[playerid][pDialogProgress][1] = 9;
			            ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "퇴장 픽업 인테리어 번호 변경", ""#C_WHITE"변경하실 건물의 퇴장 픽업 인테리어 번호를 입력해주세요.", "확인", "이전");

                        SendErrorMessage(playerid, "다시 입력해주세요.");
					}
			    }
			    else if(PlayerInfo[playerid][pDialogProgress][1] == 10)
			    {
			        if(BuildInfo[PlayerInfo[playerid][pTempBuildIndex]][bType] != 0)
			        {
			            PlayerInfo[playerid][pDialogProgress][0] = 0;
						PlayerInfo[playerid][pDialogProgress][1] = 0;

						SendErrorMessage(playerid, "입장/퇴장 타입의 픽업만 변경할 수 있습니다.");
						return 1;
			        }
			        if(strlen(inputtext))
					{
					    if(BuildInfo[PlayerInfo[playerid][pTempBuildIndex]][bCreate] == 1)
					    {
						    new index 	 = PlayerInfo[playerid][pTempBuildIndex],
 					        	virtualworld = strval(inputtext);
						    if(0 <= virtualworld < 2147483647)
						    {
						        PlayerInfo[playerid][pDialogProgress][0] = 0;
								PlayerInfo[playerid][pDialogProgress][1] = 0;

							    BuildInfo[index][bOutVirtualWorld] = virtualworld;
							    BuildDataSave(BuildInfo[index][bNumber]);
							}
							else
							{
								PlayerInfo[playerid][pDialogProgress][1] = 10;
					            ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "퇴장 픽업 가상세계 번호 변경", ""#C_WHITE"변경하실 건물의 퇴장 픽업 가상세계 번호를 입력해주세요.", "확인", "이전");

		                        SendErrorMessage(playerid, "다시 입력해주세요.");
							}
						}
						else
			            {
			                PlayerInfo[playerid][pDialogProgress][0] = 0;
							PlayerInfo[playerid][pDialogProgress][1] = 0;

			                SendErrorMessage(playerid, "존재하지 않는 건물입니다.");
			            }
					}
					else
					{
					    PlayerInfo[playerid][pDialogProgress][1] = 10;
			            ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_INPUT, "퇴장 픽업 가상세계 번호 변경", ""#C_WHITE"변경하실 건물의 퇴장 픽업 가상세계 번호를 입력해주세요.", "확인", "이전");

                        SendErrorMessage(playerid, "다시 입력해주세요.");
					}
			    }
	            else
	            {
			        if(listitem == 0)
			        {
			            if(PlayerInfo[playerid][pDialogProgress][0] == 1 && PlayerInfo[playerid][pDialogProgress][1] == 1)
			            {
			            	ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_LIST, "건물생성", "인테리어 생성\n입장퇴장 생성", "확인", "이전");
							PlayerInfo[playerid][pDialogProgress][0] = 2;
			            }
			            else if(PlayerInfo[playerid][pDialogProgress][0] == 2)
			            {
			                ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_LIST, "인테리어 생성", "집 생성\n사업장 생성", "확인", "이전");
			                PlayerInfo[playerid][pDialogProgress][0] = 3;
			            }
			            else if(PlayerInfo[playerid][pDialogProgress][0] == 3)
			            {
			                new str[512], number = 0;
			                for(new i = 0; i < sizeof(InteriorInfo); i ++)
			                {
			                    if(InteriorInfo[i][iType] == 1)
			                    {
			                        if(!strlen(str))
										{ format(str, sizeof(str), "%s", InteriorInfo[i][iName]); }
	                                else
										{ format(str, sizeof(str), "%s\n%s", str, InteriorInfo[i][iName]); }
									PlayerInfo[playerid][pDialogBuildNum][number] = i;
									number ++;
			                    }
			                }
			                ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_LIST, "집 생성", str, "확인", "이전");
			                PlayerInfo[playerid][pDialogProgress][0] = 4;
			            }
			        }
			        if(listitem == 1)
			        {
			            if(PlayerInfo[playerid][pDialogProgress][0] == 1 && PlayerInfo[playerid][pDialogProgress][1] == 1)
			            {
			                new string[512];
							format(string, sizeof(string), "ID\tType\tName");
							
							new number = 0;
							
							for(new i = 0; i < MAX_BUILD; i ++)
							{
							    if(BuildInfo[i][bCreate] == 1)
							    {
									format(string, sizeof(string), "%s\n%d\t%s\t%s", string, BuildInfo[i][bNumber], BuildTypeName(BuildInfo[i][bType]), BuildInfo[i][bName]);
									
									PlayerInfo[playerid][pTempBuildIndexs][number] = i;
									number++;
								}
							}
			                ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_TABLIST_HEADERS, "건물관리", string, "확인", "이전");
			                PlayerInfo[playerid][pDialogProgress][1] = 2;
			            }
						else if(PlayerInfo[playerid][pDialogProgress][0] == 2)
						{
						    new Float:x, Float:y, Float:z, interior, virtualworld;
						    
						    GetPlayerPos(playerid, x, y, z);
						    virtualworld = GetPlayerVirtualWorld(playerid);
						    interior = GetPlayerInterior(playerid);
						    
						    PlayerInfo[playerid][pBuildInPos][0] = x;
						    PlayerInfo[playerid][pBuildInPos][1] = y;
						    PlayerInfo[playerid][pBuildInPos][2] = z;
						    PlayerInfo[playerid][pBuildInInterior] = interior;
						    PlayerInfo[playerid][pBuildInVirtualWorld] = virtualworld;
						    PlayerInfo[playerid][pDialogProgress][0] = 9;
							SendMessage(playerid, "퇴장할 좌표에 가서 '/건물관리'를 타이핑 해주세요.");
						    // ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_TABLIST_HEADERS, "건물관리", string, "확인", "이전");
						}
						else if(PlayerInfo[playerid][pDialogProgress][0] == 3)
						{
						    new str[512], number = 0;
			                for(new i = 0; i < sizeof(InteriorInfo); i ++)
			                {
			                    if(InteriorInfo[i][iType] == 2)
			                    {
			                        if(!strlen(str))
										{ format(str, sizeof(str), "%s", InteriorInfo[i][iName]); }
	                                else
										{ format(str, sizeof(str), "%s\n%s", str, InteriorInfo[i][iName]); }
									PlayerInfo[playerid][pDialogBuildNum][number] = i;
									number ++;
			                    }
			                }
			                ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_LIST, "사업장 생성", str, "확인", "이전");
			                PlayerInfo[playerid][pDialogProgress][0] = 6;
						}
			        }
				}
		    }
		    else
		    {
		        if(PlayerInfo[playerid][pDialogProgress][0] == 1 && PlayerInfo[playerid][pDialogProgress][1] == 1) return 0;
		        else if(PlayerInfo[playerid][pDialogProgress][0] == 2 || PlayerInfo[playerid][pDialogProgress][1] == 2) return OnPlayerCommandText(playerid, "/건물관리");
		        else if(PlayerInfo[playerid][pDialogProgress][0] == 3)
				{
					ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_LIST, "건물생성", "인테리어 생성\n입장퇴장 생성", "확인", "이전");
					PlayerInfo[playerid][pDialogProgress][0] = 2;
					return 0;
				}
				else if(PlayerInfo[playerid][pDialogProgress][0] == 4 || PlayerInfo[playerid][pDialogProgress][0] == 6)
				{
				    ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_LIST, "인테리어 생성", "집 생성\n사업장 생성", "확인", "이전");
				    PlayerInfo[playerid][pDialogProgress][0] = 3;
				    return 0;
				}
				else if(PlayerInfo[playerid][pDialogProgress][0] == 5)
				{
				    new str[512], number = 0;
	                for(new i = 0; i < sizeof(InteriorInfo); i ++)
	                {
	                    if(InteriorInfo[i][iType] == 1)
	                    {
	                        if(!strlen(str))
								{ format(str, sizeof(str), "%s", InteriorInfo[i][iName]); }
                            else
								{ format(str, sizeof(str), "%s\n%s", str, InteriorInfo[i][iName]); }
							PlayerInfo[playerid][pDialogBuildNum][number] = i;
							number ++;
	                    }
	                }
	                ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_LIST, "집 생성", str, "확인", "이전");
	                PlayerInfo[playerid][pDialogProgress][0] = 4;
				    return 0;
				}
				else if(PlayerInfo[playerid][pDialogProgress][0] == 7)
				{
				    new str[512], number = 0;
	                for(new i = 0; i < sizeof(InteriorInfo); i ++)
	                {
	                    if(InteriorInfo[i][iType] == 2)
	                    {
	                        if(!strlen(str))
								{ format(str, sizeof(str), "%s", InteriorInfo[i][iName]); }
                            else
								{ format(str, sizeof(str), "%s\n%s", str, InteriorInfo[i][iName]); }
							PlayerInfo[playerid][pDialogBuildNum][number] = i;
							number ++;
	                    }
	                }
	                ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_LIST, "사업장 생성", str, "확인", "이전");
	                PlayerInfo[playerid][pDialogProgress][0] = 6;
	                return 0;
				}
                else if(PlayerInfo[playerid][pDialogProgress][0] == 10)
                {
                    ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_LIST, "퇴장위치 관리", DialogListStyle("퇴장위치 확정\n건물생성 취소"), "확인", "취소");
                    PlayerInfo[playerid][pDialogProgress][0] = 9;
                }
                else if(PlayerInfo[playerid][pDialogProgress][1] == 3)
                {
                    new string[512];
					format(string, sizeof(string), "ID\tType\tName");

					new number = 0;

					for(new i = 0; i < MAX_BUILD; i ++)
					{
					    if(BuildInfo[i][bCreate] == 1)
					    {
							format(string, sizeof(string), "%s\n%d\t%s\t%s", string, BuildInfo[i][bNumber], BuildTypeName(BuildInfo[i][bType]), BuildInfo[i][bName]);

							PlayerInfo[playerid][pTempBuildIndexs][number] = i;
							number++;
						}
					}
	                ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_TABLIST_HEADERS, "건물관리", string, "확인", "이전");
	                PlayerInfo[playerid][pDialogProgress][1] = 2;
                }
                else if(PlayerInfo[playerid][pDialogProgress][1] == 4 || PlayerInfo[playerid][pDialogProgress][1] == 5 || PlayerInfo[playerid][pDialogProgress][1] == 6 || PlayerInfo[playerid][pDialogProgress][1] == 7 || PlayerInfo[playerid][pDialogProgress][1] == 8 || PlayerInfo[playerid][pDialogProgress][1] == 9 || PlayerInfo[playerid][pDialogProgress][1] == 10)
				{
				    PlayerInfo[playerid][pDialogProgress][1] = 3;
				    // PlayerInfo[playerid][pTempBuildIndex] = PlayerInfo[playerid][pTempBuildIndexs][listitem + 1];

					ShowPlayerDialog(playerid, DIALOG_BUILD_EDIT, DIALOG_STYLE_LIST, "건물관리", DialogListStyle("건물이름 변경\n입장위치 변경\n퇴장위치 변경\n입장 픽업 인테리어 번호 변경\n입장 픽업 가상세계 번호 변경\n퇴장 픽업 인테리어 번호 변경\n퇴장 픽업 가상세계 번호 변경"), "확인", "이전");
				}
		    }
		}
		case DIALOG_ITEM_CLICK:
		{
		    if(response)
		    {
		        if(listitem == 0) // 사용하기
		        {
		            switch(InvenItem[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemClick]])
		            {
		                case 1: // 휴대전화
						{
						    InventoryMode(playerid, false);
							OnPlayerCommandText(playerid, "/폰 열기");
				        }
		            }
		        }
		        if(listitem == 1) // 주기
		        {
		            if(IsItemGive(InvenItem[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemClick]]))
		            {
			            new aroundPlayer[MAX_PLAYERS], allPlayer = 0;
			            AroundPlayerList(playerid, ITEM_EXCHANGE, aroundPlayer, allPlayer);

	                    PlayerInfo[playerid][pInventoryMode] = false;
				        CancelSelectTextDraw(playerid);

	                    PlayerInfo[playerid][pDialogProgress][0] = 1;

						new string[512];
						format(string, sizeof(string), ""#C_GRAY"ID\tName"#C_WHITE"");
						for(new i = 0; i < allPlayer; i ++)
						{
						    format(string, sizeof(string), "%s\n%d\t\t%s", string, aroundPlayer[i], PlayerNameEx(aroundPlayer[i]));
						    PlayerInfo[playerid][pGive_Item_Index][i] = aroundPlayer[i];
						}
			            ShowPlayerDialog(playerid, DIALOG_INVEN_GIVE, DIALOG_STYLE_LIST, "아이템 주기", string, "확인", "이전");
					}
					else
					{
					    SendErrorMessage(playerid, "이 아이템은 교환 불가능한 아이템입니다.");
					    PlayerInfo[playerid][pDialogProgress][0] = -1;

			            new str[100];
		                format(str, sizeof(str), "%s(%d개)", GetItemName(InvenItem[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemClick]]), InvenItemNum[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemClick]]);
		                ShowPlayerDialog(playerid, DIALOG_ITEM_CLICK, DIALOG_STYLE_LIST, str, DialogListStyle("사용하기\n주기\n자리이동\n버리기"), "확인", "취소");
		                return 1;
					}
		        }
		        if(listitem == 2) // 자리이동
		        {
		            PlayerInfo[playerid][pItemDisPlace][0] = -1;
			    	PlayerInfo[playerid][pItemDisPlace][1] = -1;

		            PlayerInfo[playerid][pItemDisPlace][0] = PlayerInfo[playerid][pItemClick] + START_INVEN;
			    	SendMessage(playerid, "아이템을 옮길 장소를 선택해주세요.");
			    	PlayerInfo[playerid][pInventoryMode] = true;
			    	SetTimerEx("SELECTTEXTDRAW", 100, false, "d", playerid);
		        }
		        if(listitem == 3) // 버리기
		        {
		            if(IsItemDrop(InvenItem[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemClick]]))
		            {
			            new index = PlayerInfo[playerid][pItemClick];

			            new string[200];
			            format(string, sizeof(string), "%s(%d개)아이템을 버릴 개수를 기재해주세요.", InvenItem[playerid][InvenSelectSlot[playerid]][index], InvenItemNum[playerid][InvenSelectSlot[playerid]][index]);
			            ShowPlayerDialog(playerid, DIALOG_INVEN_DROP, DIALOG_STYLE_INPUT, "아이템 버리기", string, "확인", "이전");
			        }
			        else
			        {
			            SendErrorMessage(playerid, "이 아이템은 버릴 수 없습니다.");
					    PlayerInfo[playerid][pDialogProgress][0] = -1;

			            new str[100];
		                format(str, sizeof(str), "%s(%d개)", GetItemName(InvenItem[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemClick]]), InvenItemNum[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemClick]]);
		                ShowPlayerDialog(playerid, DIALOG_ITEM_CLICK, DIALOG_STYLE_LIST, str, DialogListStyle("사용하기\n주기\n자리이동\n버리기"), "확인", "취소");
		                return 1;
			        }
				}
		    }
			else
			{
			    PlayerInfo[playerid][pInventoryMode] = true;
			    SetTimerEx("SELECTTEXTDRAW", 100, false, "d", playerid);
			}
			return 1;
		}
		case DIALOG_INVEN_GIVE:
		{
		    if(response)
		    {
		        if(PlayerInfo[playerid][pDialogProgress][0] == 1)
		        {
		            if(listitem == 0)
					{
					    new aroundPlayer[MAX_PLAYERS], allPlayer = 0;
			            AroundPlayerList(playerid, ITEM_EXCHANGE, aroundPlayer, allPlayer);

	                    PlayerInfo[playerid][pInventoryMode] = false;
				        CancelSelectTextDraw(playerid);

	                    PlayerInfo[playerid][pDialogProgress][0] = 1;

						new string[512];
						format(string, sizeof(string), ""#C_GRAY"ID\tName"#C_WHITE"");
						for(new i = 0; i < allPlayer; i ++)
						{
						    format(string, sizeof(string), "%s\n%d\t\t%s", string, aroundPlayer[i], PlayerNameEx(aroundPlayer[i]));
						    PlayerInfo[playerid][pGive_Item_Index][i] = aroundPlayer[i];
						}
			            ShowPlayerDialog(playerid, DIALOG_INVEN_GIVE, DIALOG_STYLE_LIST, "아이템 주기", string, "확인", "이전");
			            return 1;
					}
		        
			        PlayerInfo[playerid][pGive_Item_Player] = PlayerInfo[playerid][pGive_Item_Index][listitem-1];
                    PlayerInfo[playerid][pDialogProgress][0]  = 2;
                    
                    new index = PlayerInfo[playerid][pItemClick];
                    
                    new string[200];
                    format(string, sizeof(string), ""#C_WHITE"%s(%d개)의 아이템을 %s님에게 줄 개수를 입력해주세요.", 	GetItemName(InvenItem[playerid][InvenSelectSlot[playerid]][index]),
																													InvenItemNum[playerid][InvenSelectSlot[playerid]][index],
																													PlayerNameEx(PlayerInfo[playerid][pGive_Item_Player]));
			        ShowPlayerDialog(playerid, DIALOG_INVEN_GIVE, DIALOG_STYLE_INPUT, "아이템 주기", string, "확인", "이전");
				}
				else if(PlayerInfo[playerid][pDialogProgress][0] == 2)
		        {
		            if(!strlen(inputtext))
					{
	                    PlayerInfo[playerid][pDialogProgress][0]  = 2;

	                    new index = PlayerInfo[playerid][pItemClick];

	                    new string[200];
	                    format(string, sizeof(string), ""#C_WHITE"%s(%d개)의 아이템을 %s님에게 줄 개수를 입력해주세요.", 	GetItemName(InvenItem[playerid][InvenSelectSlot[playerid]][index]),
																														InvenItemNum[playerid][InvenSelectSlot[playerid]][index],
																														PlayerNameEx(PlayerInfo[playerid][pGive_Item_Player]));
				        ShowPlayerDialog(playerid, DIALOG_INVEN_GIVE, DIALOG_STYLE_INPUT, "아이템 주기", string, "확인", "이전");
					    return 1;
					}
					else
					{
					    new index 	= PlayerInfo[playerid][pItemClick];
			            new number 	= strval(inputtext);
			            
						if(number > 0 && InvenItemNum[playerid][InvenSelectSlot[playerid]][index] >= number)
						{
						    PlayerInfo[playerid][pDialogProgress][0] = -1;
						    
						    if(!IsPlayerLogin(PlayerInfo[playerid][pGive_Item_Player]))
						    {
						        PlayerInfo[playerid][pInventoryMode] = true;
			    				SetTimerEx("SELECTTEXTDRAW", 100, false, "d", playerid);
			    				return 1;
						    }
						    if(IsGivePlayerDistance(ITEM_EXCHANGE, playerid, PlayerInfo[playerid][pGive_Item_Player]))
						    {
						        new giveplayerid = PlayerInfo[playerid][pGive_Item_Player];
						        new itemid = InvenItem[playerid][InvenSelectSlot[playerid]][index];
						        new result = PlayerItemAdd(giveplayerid, itemid, number);
						        if(result == -1 || result == 0 || result == -2)
						        {
						            new string[128];
						            format(string, sizeof(string), "알 수 없는 오류가 발생하였습니다. 오류코드 : %d", result);
						            SendErrorMessage(playerid, string);
						        
						            PlayerInfo[playerid][pInventoryMode] = true;
			    					SetTimerEx("SELECTTEXTDRAW", 100, false, "d", playerid);
						            return 1;
						        }
						        if(result == -3)
						        {
						            SendErrorMessage(playerid, "상대방의 가방에 꽉 차서 아이템을 줄 수 없습니다.");
						            
						            PlayerInfo[playerid][pInventoryMode] = true;
			    					SetTimerEx("SELECTTEXTDRAW", 100, false, "d", playerid);
						            return 1;
						        }
								if(result == 1)
								{
								    PlayerItemDelete(playerid, itemid, number);
								
							        new string[128];
							        format(string, sizeof(string), "당신은 %s(%d)님에게 아이템 %s를 %d개 보내주었습니다.", PlayerNameEx(giveplayerid), giveplayerid, GetItemName(itemid), number);
							        SendMessage(playerid, string);

							        format(string, sizeof(string), "당신은 %s(%d)님에게 아이템 %s를 %d개 받았습니다.", PlayerNameEx(playerid), playerid, GetItemName(itemid), number);
							        SendMessage(giveplayerid, string);
							        
							        PlayerInfo[playerid][pInventoryMode] = true;
							        PlayerItemUpdate(playerid);
								}
						    }
						}
						else
						{
						    SendErrorMessage(playerid, "당신이 소지하고 계신 개수가 부족합니다.");
						    
						    PlayerInfo[playerid][pDialogProgress][0]  = 2;

		                    index = PlayerInfo[playerid][pItemClick];

		                    new string[200];
		                    format(string, sizeof(string), ""#C_WHITE"%s(%d개)의 아이템을 %s님에게 줄 개수를 입력해주세요.", 	GetItemName(InvenItem[playerid][InvenSelectSlot[playerid]][index]),
																															InvenItemNum[playerid][InvenSelectSlot[playerid]][index],
																															PlayerNameEx(PlayerInfo[playerid][pGive_Item_Player]));
					        ShowPlayerDialog(playerid, DIALOG_INVEN_GIVE, DIALOG_STYLE_INPUT, "아이템 주기", string, "확인", "이전");
						}
					}
		        }
		    }
		    else
		    {
		        if(PlayerInfo[playerid][pDialogProgress][0] == 1)
		        {
		            PlayerInfo[playerid][pDialogProgress][0] = -1;
		            
		            new str[100];
	                format(str, sizeof(str), "%s(%d개)", GetItemName(InvenItem[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemClick]]), InvenItemNum[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemClick]]);
	                ShowPlayerDialog(playerid, DIALOG_ITEM_CLICK, DIALOG_STYLE_LIST, str, DialogListStyle("사용하기\n주기\n자리이동\n버리기"), "확인", "취소");
		        }
		        else if(PlayerInfo[playerid][pDialogProgress][0] == 2)
		        {
	                new aroundPlayer[MAX_PLAYERS], allPlayer = 0;
		            AroundPlayerList(playerid, ITEM_EXCHANGE, aroundPlayer, allPlayer);

	                PlayerInfo[playerid][pInventoryMode] = false;
			        CancelSelectTextDraw(playerid);

	                PlayerInfo[playerid][pDialogProgress][0] = 1;

					new string[512];
					format(string, sizeof(string), ""#C_GRAY"ID\tName"#C_WHITE"");
					for(new i = 0; i < allPlayer; i ++)
					{
					    format(string, sizeof(string), "%s\n%d\t\t%s", string, aroundPlayer[i], PlayerNameEx(aroundPlayer[i]));
					    PlayerInfo[playerid][pGive_Item_Index][i] = aroundPlayer[i];
					}
		            ShowPlayerDialog(playerid, DIALOG_INVEN_GIVE, DIALOG_STYLE_LIST, "아이템 주기", string, "확인", "이전");
				}
		    }
		    return 1;
		}
		case DIALOG_INVEN_DROP:
		{
			if(response)
			{
			    new index 	= PlayerInfo[playerid][pItemClick];
			    new number 	= strval(inputtext);
			    if(InvenItem[playerid][InvenSelectSlot[playerid]][index] >= number)
			    {
			        //new result = PlayerItemDrop(playerid, InvenItem[playerid][InvenSelectSlot[playerid]][index], number);
			        
			    }
			}
			else
			{
			    PlayerInfo[playerid][pDialogProgress][0] = -1;

	            new str[100];
                format(str, sizeof(str), "%s(%d개)", GetItemName(InvenItem[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemClick]]), InvenItemNum[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemClick]]);
                ShowPlayerDialog(playerid, DIALOG_ITEM_CLICK, DIALOG_STYLE_LIST, str, DialogListStyle("사용하기\n주기\n자리이동\n버리기"), "확인", "취소");
			}
			return 1;
		}
		case DIALOG_SMS:
		{
		    if(response)
		    {
		        if(PlayerInfo[playerid][pDialogProgress][0] == 1)
		        {
		            if(strval(inputtext) > 0 && strlen(inputtext) > 0)
		            {
		            	PlayerInfo[playerid][pSMSTmpPhoneNum] = strval(inputtext);
		            	PlayerInfo[playerid][pDialogProgress][0] = 2;
		            	ShowPlayerDialog(playerid, DIALOG_SMS, DIALOG_STYLE_INPUT, "메세지 보내기", ""#C_WHITE"보낼 내용을 입력해주세요.", "확인", "이전");
		            }
		            else
		            {
		                SendMessage(playerid, "다시 작성해주세요.");
		                
		                PlayerInfo[playerid][pDialogProgress][0] = 1;
		            	ShowPlayerDialog(playerid, DIALOG_SMS, DIALOG_STYLE_INPUT, "메세지 보내기", ""#C_WHITE"받을 사람의 휴대폰 번호를 입력해주세요.", "확인", "이전");
		            }
		            return 1;
		        }
		        else if(PlayerInfo[playerid][pDialogProgress][0] == 2)
		        {
		            if(strlen(inputtext) > 0)
		            {
		                new result = sendSMS(playerid, PlayerInfo[playerid][pSMSTmpPhoneNum], inputtext);
		                if(result == 1)
		                {
		                    SendMessage(playerid, "정상적으로 메세지가 발신 되었습니다.");
		                }
		                else SendErrorMessage(playerid, "없는 번호입니다.");
		                PlayerInfo[playerid][pDialogProgress][0] = 0;
		                
		                PlayerInfo[playerid][pPhoneSelChk] = true;
			    		SelectTextDraw(playerid, COLOR_CLK_PHONE);
		            }
		            else
		            {
		                SendMessage(playerid, "다시 작성해주세요.");
		                
		            	PlayerInfo[playerid][pDialogProgress][0] = 2;
		            	ShowPlayerDialog(playerid, DIALOG_SMS, DIALOG_STYLE_INPUT, "메세지 보내기", ""#C_WHITE"보낼 내용을 입력해주세요.", "확인", "이전");
		            }
		            return 1;
		        }
		        else if(PlayerInfo[playerid][pDialogProgress][1] == 1)
				{
				    PlayerInfo[playerid][pTempSmsIndexs] = PlayerInfo[playerid][pTempSmsIndex][listitem];
				    new index = PlayerInfo[playerid][pTempSmsIndexs];

					new string[400];
					format(string, sizeof(string), ""#C_GRAY"=========================================================\n"\
	    										   ""#C_WHITE"발신번호 : ☎%d\n\n"\
															"내용 : %s\n\n"\
													"수신 날짜 %04.d년 %02.d월 %02.d일 %02.d시%02.d분\n"\
													""#C_GRAY"=========================================================",
													SMSReceive_CallNum[playerid][index], string_nextLine(SMSReceive_Content[playerid][index]),
													SMSReceive_Year[playerid][index], SMSReceive_Month[playerid][index], SMSReceive_Day[playerid][index],
													SMSReceive_Hour[playerid][index], SMSReceive_Minute[playerid][index]);
					ShowPlayerDialog(playerid, DIALOG_SMS, DIALOG_STYLE_INPUT, "메세지 수신함", string, "답장", "이전");
					PlayerInfo[playerid][pSMSTmpPhoneNum] = SMSReceive_CallNum[playerid][index];
					SMSReceive_HitChk[playerid][index] = 0;
				    PlayerInfo[playerid][pDialogProgress][1] = 2;
				}
				else if(PlayerInfo[playerid][pDialogProgress][1] == 2)
				{
				    if(strlen(inputtext) > 0)
		            {
					    new result = sendSMS(playerid, PlayerInfo[playerid][pSMSTmpPhoneNum], inputtext);
					    if(result == 1)
					    {
					        SendMessage(playerid, "정상적으로 메세지가 발신 되었습니다.");
					    }
					    else SendErrorMessage(playerid, "없는 번호입니다.");
					    
					    PlayerInfo[playerid][pPhoneSelChk] = true;
			    		SelectTextDraw(playerid, COLOR_CLK_PHONE);
					    
					    PlayerInfo[playerid][pDialogProgress][1] = 0;
					}
					else
					{
					    new index = PlayerInfo[playerid][pTempSmsIndexs];

						new string[400];
						format(string, sizeof(string), ""#C_GRAY"=========================================================\n"\
		    										   ""#C_WHITE"발신번호 : ☎%d\n\n"\
																"내용 : %s\n\n"\
														"수신 날짜 %04.d년 %02.d월 %02.d일 %02.d시%02.d분\n"\
														""#C_GRAY"=========================================================",
														SMSReceive_CallNum[playerid][index], string_nextLine(SMSReceive_Content[playerid][index]),
														SMSReceive_Year[playerid][index], SMSReceive_Month[playerid][index], SMSReceive_Day[playerid][index],
														SMSReceive_Hour[playerid][index], SMSReceive_Minute[playerid][index]);
						ShowPlayerDialog(playerid, DIALOG_SMS, DIALOG_STYLE_INPUT, "메세지 수신함", string, "답장", "이전");
						PlayerInfo[playerid][pSMSTmpPhoneNum] = SMSReceive_CallNum[playerid][index];
					    PlayerInfo[playerid][pDialogProgress][1] = 2;
					}
				}
				else if(PlayerInfo[playerid][pDialogProgress][2] == 1)
				{
				    new index = PlayerInfo[playerid][pTempSmsIndex][listitem];

					new string[400];
					format(string, sizeof(string), ""#C_GRAY"=========================================================\n"\
	    										   ""#C_WHITE"수신번호 : ☎%d\n\n"\
															"내용 : %s\n\n"\
													"발신 날짜 %04.d년 %02.d월 %02.d일 %02.d시%02.d분\n"\
													""#C_GRAY"=========================================================",
													SMSSend_CallNum[playerid][index], string_nextLine(SMSSend_Content[playerid][index]),
													SMSSend_Year[playerid][index], SMSSend_Month[playerid][index], SMSSend_Day[playerid][index],
													SMSSend_Hour[playerid][index], SMSSend_Minute[playerid][index]);
					ShowPlayerDialog(playerid, DIALOG_SMS, DIALOG_STYLE_MSGBOX, "메세지 발신함", string, "확인", "이전");
				    PlayerInfo[playerid][pDialogProgress][2] = 2;
				}
				else if(PlayerInfo[playerid][pDialogProgress][2] == 2)
				{
				    PlayerInfo[playerid][pDialogProgress][2] = 0;
				
					PlayerInfo[playerid][pPhoneSelChk] = true;
			    	SelectTextDraw(playerid, COLOR_CLK_PHONE);
				}
		        else
		        {
			        if(listitem == 0)
			        {
			            PlayerInfo[playerid][pDialogProgress][0] = 1;
			            ShowPlayerDialog(playerid, DIALOG_SMS, DIALOG_STYLE_INPUT, "메세지 보내기", ""#C_WHITE"받을 사람의 휴대폰 번호를 입력해주세요.", "확인", "이전");
			        }
			        if(listitem == 1)
			        {
			            new string[512];
			            new number = 0;
			            PlayerInfo[playerid][pDialogProgress][1] = 1;
						strmid(string, ""#C_WHITE"☎\t"#C_WHITE"Content", 0, 256, 256);
						for(new i = MAX_SMS-1; i >= 0; i --)
						{
							if(SMSReceive_CallNum[playerid][i] != -1)
							{
						    	if(SMSReceive_HitChk[playerid][i] == 1) format(string, sizeof(string), "%s\n"#C_WHITE"%d\t"#C_WHITE"%s...", string, SMSReceive_CallNum[playerid][i], string_cut(SMSReceive_Content[playerid][i], 15));
						    	else format(string, sizeof(string), "%s\n"#C_GRAY"%d\t"#C_GRAY"%s...", string, SMSReceive_CallNum[playerid][i], string_cut(SMSReceive_Content[playerid][i], 15));
						    	PlayerInfo[playerid][pTempSmsIndex][number] = i;
						    	number++;
						    }
						}
						ShowPlayerDialog(playerid, DIALOG_SMS, DIALOG_STYLE_TABLIST_HEADERS, "메세지 수신함", string, "확인", "이전");
			        }
			        if(listitem == 2)
			        {
			            new string[512];
			            new number = 0;
			            PlayerInfo[playerid][pDialogProgress][2] = 1;
						strmid(string, ""#C_WHITE"☎\t"#C_WHITE"Content", 0, 256, 256);
						for(new i = MAX_SMS-1; i >= 0; i --)
						{
							if(SMSSend_CallNum[playerid][i] != -1)
							{
						    	format(string, sizeof(string), "%s\n%d\t%s...", string, SMSSend_CallNum[playerid][i], string_cut(SMSSend_Content[playerid][i], 15));
						    	PlayerInfo[playerid][pTempSmsIndex][number] = i;
						    	number++;
						    }
						}
						ShowPlayerDialog(playerid, DIALOG_SMS, DIALOG_STYLE_TABLIST_HEADERS, "메세지 발신함", string, "확인", "이전");
			        }
				}
		    }
		    else
		    {
		        if(PlayerInfo[playerid][pDialogProgress][0] == 0 && PlayerInfo[playerid][pDialogProgress][1] == 0 && PlayerInfo[playerid][pDialogProgress][2] == 0)
		        {
			        PlayerInfo[playerid][pPhoneSelChk] = true;
				    SelectTextDraw(playerid, COLOR_CLK_PHONE);
				}
		        if(PlayerInfo[playerid][pDialogProgress][0] == 1 || PlayerInfo[playerid][pDialogProgress][1] == 1 || PlayerInfo[playerid][pDialogProgress][2] == 1)
		        {
		            PlayerInfo[playerid][pDialogProgress][0] = 0;
					PlayerInfo[playerid][pDialogProgress][1] = 0;
					PlayerInfo[playerid][pDialogProgress][2] = 0;
				    ShowPlayerDialog(playerid, DIALOG_SMS, DIALOG_STYLE_LIST, "문자메세지", "문자보내기\n문자수신함\n문자발신함", "확인", "취소");
		        }
		        if(PlayerInfo[playerid][pDialogProgress][0] == 2)
		        {
		            PlayerInfo[playerid][pDialogProgress][0] = 1;
		            ShowPlayerDialog(playerid, DIALOG_SMS, DIALOG_STYLE_INPUT, "메세지 보내기", ""#C_WHITE"받을 사람의 휴대폰 번호를 입력해주세요.", "확인", "이전");
		        }
				if(PlayerInfo[playerid][pDialogProgress][1] == 2)
				{
				    new string[512];
				    new number = 0;
				    PlayerInfo[playerid][pDialogProgress][1] = 1;
					strmid(string, ""#C_WHITE"☎\t"#C_WHITE"Content", 0, sizeof(string), sizeof(string));
					for(new i = MAX_SMS-1; i >= 0; i --)
					{
						if(SMSReceive_CallNum[playerid][i] != -1)
						{
					    	if(SMSReceive_HitChk[playerid][i] == 1) format(string, sizeof(string), "%s\n"#C_WHITE"%d\t"#C_WHITE"%s...", string, SMSReceive_CallNum[playerid][i], string_cut(SMSReceive_Content[playerid][i], 15));
					    	else format(string, sizeof(string), "%s\n"#C_GRAY"%d\t"#C_GRAY"%s...", string, SMSReceive_CallNum[playerid][i], string_cut(SMSReceive_Content[playerid][i], 15));
					    	PlayerInfo[playerid][pTempSmsIndex][number] = i;
					    	number ++;
					    }
					}
					ShowPlayerDialog(playerid, DIALOG_SMS, DIALOG_STYLE_TABLIST_HEADERS, "메세지 수신함", string, "확인", "이전");
				}
				if(PlayerInfo[playerid][pDialogProgress][2] == 2)
				{
				    new string[512];
				    new number = 0;
				    PlayerInfo[playerid][pDialogProgress][2] = 1;
					strmid(string, ""#C_WHITE"☎\t"#C_WHITE"Content", 0, sizeof(string), sizeof(string));
					for(new i = MAX_SMS-1; i >= 0; i --)
					{
						if(SMSSend_CallNum[playerid][i] != -1)
						{
					    	format(string, sizeof(string), "%s\n%d\t%s...", string, SMSSend_CallNum[playerid][i], string_cut(SMSSend_Content[playerid][i], 15));
					    	PlayerInfo[playerid][pTempSmsIndex][number] = i;
						    number ++;
					    }
					}
					ShowPlayerDialog(playerid, DIALOG_SMS, DIALOG_STYLE_TABLIST_HEADERS, "메세지 발신함", string, "확인", "이전");
				}
		    }
		    return 1;
		}
		case DIALOG_NOTE:
		{
		    if(response)
		    {
				if(PlayerInfo[playerid][pDialogProgress][0] == 1)
				{
				    if(strlen(inputtext))
				    {
				        PlayerInfo[playerid][pDialogProgress][0] = 0;
				        new result = privateNoteDatabaseGenerate(playerid, inputtext);
				        if(result == 1)
				        {
				            SendMessage(playerid, "노트가 작성 되었습니다.");
				        }
				        else SendErrorMessage(playerid, "더 이상 노트를 작성 할 수 없습니다.");
				        PlayerInfo[playerid][pPhoneSelChk] = true;
			    		SelectTextDraw(playerid, COLOR_CLK_PHONE);
				    }
				    else
				    {
				        PlayerInfo[playerid][pDialogProgress][0] = 1;
						ShowPlayerDialog(playerid, DIALOG_NOTE, DIALOG_STYLE_INPUT, "개인노트 글쓰기", ""#C_WHITE"노트에 작성할 내용을 입력해주세요.", "확인", "이전");
				    }
				}
				else if(PlayerInfo[playerid][pDialogProgress][1] == 1)
				{
                    PlayerInfo[playerid][pTempNoteIndex2] = PlayerInfo[playerid][pTempNoteIndex][listitem];
                    new index = PlayerInfo[playerid][pTempNoteIndex2];

					new string[400];
					format(string, sizeof(string), ""#C_GRAY"=========================================================\n"\
															"내용 : %s\n\n"\
													"작성 날짜 %04.d년 %02.d월 %02.d일 %02.d시%02.d분\n"\
													""#C_GRAY"=========================================================",
													string_nextLine(privateNote_Content[playerid][index]), privateNote_Date[playerid][index][0],
													privateNote_Date[playerid][index][1], privateNote_Date[playerid][index][2],
													privateNote_Time[playerid][index][0], privateNote_Time[playerid][index][1]);
					ShowPlayerDialog(playerid, DIALOG_NOTE, DIALOG_STYLE_INPUT, "개인노트 관림", string, "수정", "이전");
				    PlayerInfo[playerid][pDialogProgress][1] = 2;
				}
				else if(PlayerInfo[playerid][pDialogProgress][1] == 2)
				{
				    if(strlen(inputtext))
				    {
				        new year, month, day,
						hour, minute, second;

						getdate(year, month, day);
						gettime(hour, minute, second);
				    
				        new index = PlayerInfo[playerid][pTempNoteIndex2];
				        
				        strmid(privateNote_Content[playerid][index], inputtext, 0, 128+1, 128+1);
				        privateNote_Create[playerid][index] = 1;
				        privateNote_Date[playerid][index][0] = year; privateNote_Date[playerid][index][1] = month; privateNote_Date[playerid][index][2] = day;
						privateNote_Time[playerid][index][0] = hour; privateNote_Time[playerid][index][1] = minute;
						PlayerInfo[playerid][pDialogProgress][1] = 0;
						SendMessage(playerid, "글 수정이 완료 되었습니다.");
						
						PlayerInfo[playerid][pPhoneSelChk] = true;
				    	SelectTextDraw(playerid, COLOR_CLK_PHONE);
				    	
				    	OnPlayerSave(playerid, 3, index);
				    }
				    else
				    {
				        SendErrorMessage(playerid, "다시 작성해주세요.");
				    
	                    new index = PlayerInfo[playerid][pTempNoteIndex2];

						new string[400];
						format(string, sizeof(string), ""#C_GRAY"=========================================================\n"\
																"내용 : %s\n\n"\
														"작성 날짜 %04.d년 %02.d월 %02.d일 %02.d시%02.d분\n"\
														""#C_GRAY"=========================================================",
														string_nextLine(privateNote_Content[playerid][index]), privateNote_Date[playerid][index][0],
														privateNote_Date[playerid][index][1], privateNote_Date[playerid][index][2],
														privateNote_Time[playerid][index][0], privateNote_Time[playerid][index][1]);
						ShowPlayerDialog(playerid, DIALOG_NOTE, DIALOG_STYLE_INPUT, "개인노트 관림", string, "수정", "이전");
					    PlayerInfo[playerid][pDialogProgress][1] = 2;
				    }
				}
				else if(PlayerInfo[playerid][pDialogProgress][2] == 1)
				{
				    PlayerInfo[playerid][pDialogProgress][2] = 0;
					new result = privateNoteDatabaseDelete(playerid, PlayerInfo[playerid][pTempNoteIndex][listitem]);
					if(result == 1)
					{
					    SendMessage(playerid, "노트가 정상적으로 삭제 되었습니다.");
					    
					    PlayerInfo[playerid][pPhoneSelChk] = true;
				    	SelectTextDraw(playerid, COLOR_CLK_PHONE);
					}
					else
					{
					    SendErrorMessage(playerid, "알 수 없는 오류로 노트가 삭제되지 않았습니다. 다시 시도해주세요.");
					
					    PlayerInfo[playerid][pPhoneSelChk] = true;
				    	SelectTextDraw(playerid, COLOR_CLK_PHONE);
					}
				}
				else
				{
				    if(listitem == 0) // 글쓰기
				    {
						for(new i = 0; i < MAX_NOTE; i ++)
						{
						    if(privateNote_Create[playerid][i] == 0)
						    {
						        PlayerInfo[playerid][pDialogProgress][0] = 1;
								ShowPlayerDialog(playerid, DIALOG_NOTE, DIALOG_STYLE_INPUT, "개인노트 글쓰기", ""#C_WHITE"노트에 작성할 내용을 입력해주세요.", "확인", "이전");
								break;
						    }
						    else if(i == MAX_NOTE-1)
						    {
						        SendErrorMessage(playerid, "더 이상 노트를 작성 할 수 없습니다.");
						        
						        PlayerInfo[playerid][pPhoneSelChk] = true;
				    			SelectTextDraw(playerid, COLOR_CLK_PHONE);
						    }
						}
				    }
				    if(listitem == 1) // 글보기
				    {
				        new string[512];
					    new number = 0;
					    PlayerInfo[playerid][pDialogProgress][1] = 1;
						strmid(string, ""#C_WHITE"Number\t"#C_WHITE"Content", 0, sizeof(string), sizeof(string));
						for(new i = 0; i < MAX_NOTE; i ++)
						{
							if(privateNote_Create[playerid][i] != 0)
							{
						    	format(string, sizeof(string), "%s\n%d\t%s...", string, i+1, string_cut(privateNote_Content[playerid][i], 15));
						    	PlayerInfo[playerid][pTempNoteIndex][number] = i;
							    number ++;
						    }
						}
						ShowPlayerDialog(playerid, DIALOG_NOTE, DIALOG_STYLE_TABLIST_HEADERS, "개인노트 관람", string, "확인", "이전");
					}
					if(listitem == 2) // 삭제
					{
					    new string[512];
					    new number = 0;
					    PlayerInfo[playerid][pDialogProgress][2] = 1;
						strmid(string, ""#C_WHITE"Number\t"#C_WHITE"Content", 0, sizeof(string), sizeof(string));
						for(new i = 0; i < MAX_NOTE; i ++)
						{
							if(privateNote_Create[playerid][i] != 0)
							{
						    	format(string, sizeof(string), "%s\n%d\t%s...", string, i+1, string_cut(privateNote_Content[playerid][i], 15));
						    	PlayerInfo[playerid][pTempNoteIndex][number] = i;
							    number ++;
						    }
						}
						ShowPlayerDialog(playerid, DIALOG_NOTE, DIALOG_STYLE_TABLIST_HEADERS, "개인노트 삭제", string, "확인", "이전");
					}
				}
			}
			else
			{
			    if(PlayerInfo[playerid][pDialogProgress][0] == 0 && PlayerInfo[playerid][pDialogProgress][1] == 0 && PlayerInfo[playerid][pDialogProgress][2] == 0)
		        {
			        PlayerInfo[playerid][pPhoneSelChk] = true;
				    SelectTextDraw(playerid, COLOR_CLK_PHONE);
				}
			    else if(PlayerInfo[playerid][pDialogProgress][0] == 1 || PlayerInfo[playerid][pDialogProgress][1] == 1 || PlayerInfo[playerid][pDialogProgress][2] == 1)
			    {
			        PlayerInfo[playerid][pDialogProgress][0] = 0;
			        PlayerInfo[playerid][pDialogProgress][1] = 0;
			        PlayerInfo[playerid][pDialogProgress][2] = 0;
			        
			        ShowPlayerDialog(playerid, DIALOG_NOTE, DIALOG_STYLE_LIST, "개인노트", DialogListStyle("노트작성\n노트보기\n노트제거"), "확인", "취소");
			    }
			    else if(PlayerInfo[playerid][pDialogProgress][1] == 2)
			    {
			        new string[512];
				    new number = 0;
				    PlayerInfo[playerid][pDialogProgress][1] = 1;
					strmid(string, ""#C_WHITE"Number\t"#C_WHITE"Content", 0, sizeof(string), sizeof(string));
					for(new i = 0; i < MAX_NOTE; i ++)
					{
						if(privateNote_Create[playerid][i] != 0)
						{
					    	format(string, sizeof(string), "%s\n%d\t%s...", string, i+1, string_cut(privateNote_Content[playerid][i], 15));
					    	PlayerInfo[playerid][pTempNoteIndex][number] = i;
						    number ++;
					    }
					}
					ShowPlayerDialog(playerid, DIALOG_NOTE, DIALOG_STYLE_TABLIST_HEADERS, "개인노트 관람", string, "확인", "이전");
			    }
			}
			return 1;
		}
		case DIALOG_NUM_NOTE:
		{
		    if(response)
		    {
		        if(PlayerInfo[playerid][pDialogProgress][0] == 1)
		        {
		            if(strlen(inputtext))
		            {
		                new number = strval(inputtext);
		            
		                new query[200];
						format(query, sizeof(query), "SELECT `pPhoneNumber` FROM `%s` WHERE `pPhoneNumber` = '%d' LIMIT 1", MySQL_USER, number);
						new Cache:result = mysql_query(MySQL, query, true);

						if(cache_num_rows())
						{
			                PlayerInfo[playerid][pDialogProgress][0] = 0;
			                PlayerInfo[playerid][pPhoneSelChk] = true;
					    	SelectTextDraw(playerid, COLOR_CLK_PHONE);
	                        new result2 = numNoteDatabaseGenerate(playerid, number);
	                        if(result2 == 1)
	                        {
	                            SendMessage(playerid, "전화번호부 추가가 완료 되었습니다.");
	                        }
	                        else if(result2 == 0)
	                        {
	                            SendErrorMessage(playerid, "더 이상 전화번호를 추가할 수 없습니다.");
	                        }
	                        else if(result2 == -1)
	                        {
	                            SendErrorMessage(playerid, "존재하지 않는 번호입니다. 다시 작성해주세요.");
	                            
	                            PlayerInfo[playerid][pDialogProgress][0] = 1;
								ShowPlayerDialog(playerid, DIALOG_NUM_NOTE, DIALOG_STYLE_INPUT, "전화번호부 추가", ""#C_WHITE"전화번호부에 추가하실 번호를 입력해주세요.", "확인", "이전");
	                        }
						}
						else
						{
						    SendErrorMessage(playerid, "존재하지 않는 번호입니다. 다시 작성해주세요.");
						
						    PlayerInfo[playerid][pDialogProgress][0] = 1;
							ShowPlayerDialog(playerid, DIALOG_NUM_NOTE, DIALOG_STYLE_INPUT, "전화번호부 추가", ""#C_WHITE"전화번호부에 추가하실 번호를 입력해주세요.", "확인", "이전");
						}
						cache_delete(result);
		            }
		            else
		            {
		                SendErrorMessage(playerid, "다시 작성해주세요.");
		            
		                PlayerInfo[playerid][pDialogProgress][0] = 1;
						ShowPlayerDialog(playerid, DIALOG_NUM_NOTE, DIALOG_STYLE_INPUT, "전화번호부 추가", ""#C_WHITE"전화번호부에 추가하실 번호를 입력해주세요.", "확인", "이전");
		            }
		        }
				else if(PlayerInfo[playerid][pDialogProgress][1] == 1)
				{
				    PlayerInfo[playerid][pDialogProgress][1] = 2;
				    PlayerInfo[playerid][pSMSTmpPhoneNum] = NumberNote_CallNum[playerid][listitem];
				    PlayerInfo[playerid][pNumNoteTmpIndex] = NumberNote_Index[playerid][listitem];

				    ShowPlayerDialog(playerid, DIALOG_NUM_NOTE, DIALOG_STYLE_LIST, "전화번호부", DialogListStyle("통화걸기\n문자메세지\n전화번호 삭제"), "확인", "이전");
				}
				else if(PlayerInfo[playerid][pDialogProgress][1] == 2)
				{
				    if(listitem == 0) // 통화걸기
				    {
				        PlayerInfo[playerid][pDialogProgress][1] = 0;
				        
				        new result = PlayerCall(playerid, PlayerInfo[playerid][pSMSTmpPhoneNum]);
						if(result == 1)
						{
					        for(new a = START_CALL_TD; a < END_CALL_TD; a ++)
							{
							    TextDrawHideForPlayer(playerid, PlayerPhoneTD[playerid][a]);
							}

							TextDrawShowForPlayer(playerid, PlayerPhoneTD[playerid][37]);
						}
						else
						{
							PlayerInfo[playerid][pPhoneSelChk] = true;
			    			SelectTextDraw(playerid, COLOR_CLK_PHONE);
						}
				    }
				    if(listitem == 1) // 문자메세지
				    {
				        PlayerInfo[playerid][pDialogProgress][1] = 3;
				        ShowPlayerDialog(playerid, DIALOG_NUM_NOTE, DIALOG_STYLE_INPUT, "메세지 보내기", ""#C_WHITE"보낼 내용을 입력해주세요.", "확인", "이전");
				    }
				    if(listitem == 2)
				    {
				        PlayerInfo[playerid][pDialogProgress][1] = 0;
				        
				        PlayerInfo[playerid][pPhoneSelChk] = true;
			    		SelectTextDraw(playerid, COLOR_CLK_PHONE);
			    		
				        new result = numNoteDatabaseDelete(playerid, PlayerInfo[playerid][pNumNoteTmpIndex]);
				        
				        if(result == 1) SendMessage(playerid, "전화번호가 삭제 되었습니다.");
				        else SendErrorMessage(playerid, "전화번호가 삭제되지 않았습니다.");
				    }
				}
				else if(PlayerInfo[playerid][pDialogProgress][1] == 3)
				{
				    if(strlen(inputtext))
				    {
				        new result = sendSMS(playerid, PlayerInfo[playerid][pSMSTmpPhoneNum], inputtext);
		                if(result == 1)
		                {
		                    SendMessage(playerid, "정상적으로 메세지가 발신 되었습니다.");
		                }
		                else SendErrorMessage(playerid, "없는 번호입니다.");
		                PlayerInfo[playerid][pDialogProgress][1] = 0;

		                PlayerInfo[playerid][pPhoneSelChk] = true;
			    		SelectTextDraw(playerid, COLOR_CLK_PHONE);
				    }
				    else
				    {
				        SendErrorMessage(playerid, "다시 입력해주세요.");
				    
				        PlayerInfo[playerid][pDialogProgress][1] = 3;
				        ShowPlayerDialog(playerid, DIALOG_NUM_NOTE, DIALOG_STYLE_INPUT, "메세지 보내기", ""#C_WHITE"보낼 내용을 입력해주세요.", "확인", "이전");
				    }
				}
		        else
		        {
				    if(listitem == 0) // 전화번호부 추가
				    {
				        for(new i = 0; i < MAX_NUM_NOTE; i ++)
				        {
							if(NumberNote_Create[playerid][i] == 0)
							{
								PlayerInfo[playerid][pDialogProgress][0] = 1;
								ShowPlayerDialog(playerid, DIALOG_NUM_NOTE, DIALOG_STYLE_INPUT, "전화번호부 추가", ""#C_WHITE"전화번호부에 추가하실 번호를 입력해주세요.", "확인", "이전");
							}
							else if(i == MAX_NUM_NOTE -1)
							{
							    SendErrorMessage(playerid, "더 이상 전화번호를 추가할 수 없습니다.");

							    PlayerInfo[playerid][pPhoneSelChk] = true;
					    		SelectTextDraw(playerid, COLOR_CLK_PHONE);
							}
				        }
				    }
				    if(listitem == 1)
				    {
				        PlayerInfo[playerid][pDialogProgress][1] = 1;
				    
				        new string[512], number = 0;
				        strmid(string, "Number\tName", 0, 50, 50);
				        for(new i = 0; i < MAX_NUM_NOTE; i ++)
				        {
							if(NumberNote_Create[playerid][i] == 1)
							{
							    format(string, sizeof(string), "%s\n%d\t\t%s", string, NumberNote_CallNum[playerid][i], NumberNote_NickName[playerid][i]);
							    number++;
							}
						}
						if(number == 0)
						{
						    PlayerInfo[playerid][pDialogProgress][0] = 0;
					        PlayerInfo[playerid][pDialogProgress][1] = 0;
					        ShowPlayerDialog(playerid, DIALOG_NUM_NOTE, DIALOG_STYLE_LIST, "전화번호부", DialogListStyle("전화번호 등록\n전화번호부"), "확인", "취소");
					        
					        SendErrorMessage(playerid, "전화번호가 등록되어있지 않습니다.");
						    return 0;
						}
						ShowPlayerDialog(playerid, DIALOG_NUM_NOTE, DIALOG_STYLE_TABLIST_HEADERS, "전화번호부", string, "확인", "이전");
				    }
			    }
			}
			else
			{
			    if(PlayerInfo[playerid][pDialogProgress][0] == 0 && PlayerInfo[playerid][pDialogProgress][1] == 0)
			    {
			        PlayerInfo[playerid][pPhoneSelChk] = true;
				    SelectTextDraw(playerid, COLOR_CLK_PHONE);
			    }
			    else if(PlayerInfo[playerid][pDialogProgress][0] == 1 || PlayerInfo[playerid][pDialogProgress][1] == 1)
			    {
			        PlayerInfo[playerid][pDialogProgress][0] = 0;
			        PlayerInfo[playerid][pDialogProgress][1] = 0;
			        ShowPlayerDialog(playerid, DIALOG_NUM_NOTE, DIALOG_STYLE_LIST, "전화번호부", DialogListStyle("전화번호 등록\n전화번호부"), "확인", "취소");
			    }
			    else if(PlayerInfo[playerid][pDialogProgress][1] == 2)
			    {
			        PlayerInfo[playerid][pDialogProgress][1] = 1;

			        new string[512], number = 0;
			        strmid(string, "Number\tName", 0, 50, 50);
			        for(new i = 0; i < MAX_NUM_NOTE; i ++)
			        {
						if(NumberNote_Create[playerid][i] == 1)
						{
						    format(string, sizeof(string), "%s\n%d\t\t%s", string, NumberNote_CallNum[playerid][i], NumberNote_NickName[playerid][i]);
						    number++;
						}
					}
					if(number == 0)
					{
					    PlayerInfo[playerid][pDialogProgress][0] = 0;
				        PlayerInfo[playerid][pDialogProgress][1] = 0;
				        ShowPlayerDialog(playerid, DIALOG_NUM_NOTE, DIALOG_STYLE_LIST, "전화번호부", DialogListStyle("전화번호 등록\n전화번호부"), "확인", "취소");

				        SendErrorMessage(playerid, "전화번호가 등록되어있지 않습니다.");
					    return 0;
					}
					ShowPlayerDialog(playerid, DIALOG_NUM_NOTE, DIALOG_STYLE_TABLIST_HEADERS, "전화번호부", string, "확인", "이전");
			    }
				else if(PlayerInfo[playerid][pDialogProgress][1] == 3)
				{
				    PlayerInfo[playerid][pDialogProgress][1] = 2;
				    PlayerInfo[playerid][pSMSTmpPhoneNum] = NumberNote_CallNum[playerid][listitem-1];

				    ShowPlayerDialog(playerid, DIALOG_NUM_NOTE, DIALOG_STYLE_LIST, "전화번호부", DialogListStyle("통화걸기\n문자메세지\n전화번호 삭제"), "확인", "이전");
				}
			}
			return 1;
		}
		case DIALOG_MP3:
		{
		    if(response)
		    {
		        if(PlayerInfo[playerid][pDialogProgress][0] == 1)
		        {
		            if(strlen(inputtext))
		            {
		                PlayerInfo[playerid][pDialogProgress][0] = 0;
						Audio_StopEx(playerid, PlayerInfo[playerid][pAudio_Mp3]);
						
						PlayerInfo[playerid][pAudio_Mp3] = Audio_PlayStreamed(playerid, inputtext, false, true, false);
						
						SendMessage(playerid, "MP3가 재생 됩니다.");
						
						PlayerInfo[playerid][pPhoneSelChk] = true;
				    	SelectTextDraw(playerid, COLOR_CLK_PHONE);
		            }
		            else
		            {
		                SendErrorMessage(playerid, "다시 작성해주세요.");
		                
		                PlayerInfo[playerid][pDialogProgress][0] = 1;
					    ShowPlayerDialog(playerid, DIALOG_MP3, DIALOG_STYLE_INPUT, "음악재생", ""#C_WHITE"재생할 음악의 URL을 입력해주세요.", "확인", "이전");
		            }
		        }
				else if(PlayerInfo[playerid][pDialogProgress][1] == 1)
				{
				    if(listitem == 0) // 라이브러리 음악 추가
				    {
				        for(new i = 0; i < MAX_MP3; i ++)
				        {
				            if(playerMP3_Create[playerid][i] == 0)
							{
							    PlayerInfo[playerid][pDialogProgress][1] = 2;
							    ShowPlayerDialog(playerid, DIALOG_MP3, DIALOG_STYLE_INPUT, "라이브러리 음악 추가", ""#C_WHITE"라이브러리에 추가할 음악의 URL을 입력해주세요.", "확인", "이전");
							    
							    SendMessage(playerid, "메이플 스으으으토리");
							    break;
							}
							else if(i == MAX_MP3-1)
							{
							    SendErrorMessage(playerid, "더 이상 라이브러리에 음악을 추가할 수 없습니다.");
							    
							    PlayerInfo[playerid][pDialogProgress][1] = 1;

								new string[512];
								new number = 0;
								strmid(string, ""#C_RED"> "#C_WHITE"음악 추가\n \n"#C_GRAY"Number\tTitle"#C_WHITE"", 0, 100, 100);

								for(new mp3 = 0; mp3 < MAX_MP3; mp3 ++)
								{
								    if(playerMP3_Create[playerid][mp3] == 1)
									{
									    format(string, sizeof(string), "%s\n%d\t\t%s", string, mp3+1, playerMP3_Title[playerid][mp3]);
									    PlayerInfo[playerid][pTempMP3Indexs][number] = mp3;
										number ++;
									}
								}
		                        ShowPlayerDialog(playerid, DIALOG_MP3, DIALOG_STYLE_LIST, "라이브러리", string, "확인", "이전");
							}
				        }
				    }
					else if(0 < listitem <= 2)
					{
						PlayerInfo[playerid][pDialogProgress][1] = 1;

						new string[512];
						new number = 0;
						strmid(string, ""#C_RED"> "#C_WHITE"음악 추가\n \n"#C_GRAY"Number\tTitle"#C_WHITE"", 0, 100, 100);

						for(new i = 0; i < MAX_MP3; i ++)
						{
						    if(playerMP3_Create[playerid][i] == 1)
							{
							    format(string, sizeof(string), "%s\n%d\t\t%s", string, i+1, playerMP3_Title[playerid][i]);
								PlayerInfo[playerid][pTempMP3Indexs][number] = i;
								number ++;
							}
						}
                        ShowPlayerDialog(playerid, DIALOG_MP3, DIALOG_STYLE_LIST, "라이브러리", string, "확인", "이전");
					}
					else
					{
					    PlayerInfo[playerid][pDialogProgress][1] = 4;
					    PlayerInfo[playerid][pTempMP3Index] = PlayerInfo[playerid][pTempMP3Indexs][listitem - 3];
					    
					    ShowPlayerDialog(playerid, DIALOG_MP3, DIALOG_STYLE_LIST, "라이브러리", DialogListStyle("음악재생\n제목변경\n제거"), "확인", "이전");
					}
				}
				else if(PlayerInfo[playerid][pDialogProgress][1] == 2)
				{
					if(strlen(inputtext))
					{
					    strmid(PlayerInfo[playerid][pTempMusicURL], inputtext, 0, 128, 128);
					
					    PlayerInfo[playerid][pDialogProgress][1] = 3;
						ShowPlayerDialog(playerid, DIALOG_MP3, DIALOG_STYLE_INPUT, "라이브러리 음악 추가", ""#C_WHITE"라이브러리에 추가할 음악의 제목을 입력해주세요.", "확인", "이전");
					}
					else
					{
					    PlayerInfo[playerid][pDialogProgress][1] = 2;
						ShowPlayerDialog(playerid, DIALOG_MP3, DIALOG_STYLE_INPUT, "라이브러리 음악 추가", ""#C_WHITE"라이브러리에 추가할 음악의 URL을 입력해주세요.", "확인", "이전");
					}
				}
				else if(PlayerInfo[playerid][pDialogProgress][1] == 3)
				{
				    if(0 < strlen(inputtext) < 50)
				    {
					    PlayerInfo[playerid][pDialogProgress][1] = 0;
						new result = mp3DatabaseGenerate(playerid, inputtext, PlayerInfo[playerid][pTempMusicURL]);
						if(result == 1)
						{
						    SendMessage(playerid, "라이브러리에 노래가 추가 되었습니다.");
						}
						else
						{
						    SendErrorMessage(playerid, "노래가 추가되지 않았습니다.");
						    
						    PlayerInfo[playerid][pPhoneSelChk] = true;
				    		SelectTextDraw(playerid, COLOR_CLK_PHONE);
						}
				    }
				    else
				    {
				        SendErrorMessage(playerid, "제목은 1자 이상 50자 미만이어야 합니다.");
				    
				        PlayerInfo[playerid][pDialogProgress][1] = 3;
						ShowPlayerDialog(playerid, DIALOG_MP3, DIALOG_STYLE_INPUT, "라이브러리 음악 추가", ""#C_WHITE"라이브러리에 추가할 음악의 제목을 입력해주세요.", "확인", "이전");
				    }
				}
				else if(PlayerInfo[playerid][pDialogProgress][1] == 4)
				{
				    if(listitem == 0) // 음악 재생
				    {
				        new index = PlayerInfo[playerid][pTempMP3Index];
				        
				        PlayerInfo[playerid][pDialogProgress][1] = 0;
				        PlayerInfo[playerid][pPhoneSelChk] = true;
				        
					    SelectTextDraw(playerid, COLOR_CLK_PHONE);

						if(playerMP3_Create[playerid][index] == 1)
						{
							Audio_StopEx(playerid, PlayerInfo[playerid][pAudio_Mp3]);

							PlayerInfo[playerid][pAudio_Mp3] = Audio_PlayStreamed(playerid, playerMP3_Url[playerid][index], false, true, false);

							SendMessage(playerid, "음악이 재생됩니다.");
				        }
				    }
				    if(listitem == 1) // 음악 제목 편집
				    {
				        PlayerInfo[playerid][pDialogProgress][1] = 5;
				        ShowPlayerDialog(playerid, DIALOG_MP3, DIALOG_STYLE_INPUT, "라이브러리 편집", ""#C_WHITE"편집할 노래 제목을 입력해주세요.", "확인", "이전");
				    }
				    if(listitem == 2) // 음악 삭제
				    {
				        PlayerInfo[playerid][pDialogProgress][1] = 0;
				        PlayerInfo[playerid][pPhoneSelChk] = true;
				    
				        SelectTextDraw(playerid, COLOR_CLK_PHONE);
				    
				        new index = PlayerInfo[playerid][pTempMP3Index];
				        
				        if(playerMP3_Create[playerid][index] == 1)
						{
						    new result = mp3DatabaseDelete(playerid, index);
						    if(result == 1)
						    {
						        SendMessage(playerid, "음악이 삭제 되었습니다.");
						    }
							else SendErrorMessage(playerid, "음악이 삭제되지 않았습니다.");
						}
				    }
				}
				else if(PlayerInfo[playerid][pDialogProgress][1] == 5)
				{
				    if(strlen(inputtext))
				    {
						new index = PlayerInfo[playerid][pTempMP3Index];

				        if(playerMP3_Create[playerid][index] == 1)
						{
						    strmid(playerMP3_Title[playerid][index], inputtext, 0, 128, 128);
							SendMessage(playerid, "음악 제목이 변경 되었습니다.");
							
							OnPlayerSave(playerid, 5, index);
						}
					}
					else
					{
					    SendErrorMessage(playerid, "다시 작성해주세요.");
					
					    PlayerInfo[playerid][pDialogProgress][1] = 5;
				        ShowPlayerDialog(playerid, DIALOG_MP3, DIALOG_STYLE_INPUT, "라이브러리 편집", ""#C_WHITE"편집할 노래 제목을 입력해주세요.", "확인", "이전");
					}
				}
		        else
		        {
					if(listitem == 0) // 음악 재생
					{
					    PlayerInfo[playerid][pDialogProgress][0] = 1;
					    ShowPlayerDialog(playerid, DIALOG_MP3, DIALOG_STYLE_INPUT, "음악재생", ""#C_WHITE"재생할 음악의 URL을 입력해주세요.", "확인", "이전");
					}
					if(listitem == 1) // 음악 라이브러리
					{
                        PlayerInfo[playerid][pDialogProgress][1] = 1;

						new string[512];
						new number = 0;
						strmid(string, ""#C_RED"> "#C_WHITE"음악 추가\n \n"#C_GRAY"Number\tTitle"#C_WHITE"", 0, 100, 100);
						
						for(new i = 0; i < MAX_MP3; i ++)
						{
						    if(playerMP3_Create[playerid][i] == 1)
							{
							    format(string, sizeof(string), "%s\n%d\t\t%s", string, i+1, playerMP3_Title[playerid][i]);
							    PlayerInfo[playerid][pTempMP3Indexs][number] = i;
								number ++;
							}
						}
                        ShowPlayerDialog(playerid, DIALOG_MP3, DIALOG_STYLE_LIST, "라이브러리", string, "확인", "이전");
					}
					if(listitem == 2) // 음악 중지
					{
						if(PlayerInfo[playerid][pAudio_Mp3] != -1) SendMessage(playerid, "음악이 중지되었습니다.");
					    Audio_StopEx(playerid, PlayerInfo[playerid][pAudio_Mp3]);
					}
				}
		    }
		    else
		    {
		        if(PlayerInfo[playerid][pDialogProgress][0] == 0 && PlayerInfo[playerid][pDialogProgress][1] == 0)
				{
		            PlayerInfo[playerid][pPhoneSelChk] = true;
				    SelectTextDraw(playerid, COLOR_CLK_PHONE);
				}
				else if(PlayerInfo[playerid][pDialogProgress][0] == 1 || PlayerInfo[playerid][pDialogProgress][1] == 1)
				{
				    PlayerInfo[playerid][pDialogProgress][0] = 0;
				    PlayerInfo[playerid][pDialogProgress][1] = 0;
				    
				    ShowPlayerDialog(playerid, DIALOG_MP3, DIALOG_STYLE_LIST, "MP3", DialogListStyle("음악재생\n라이브러리\n음악정지"), "확인", "취소");
				}
				else if(PlayerInfo[playerid][pDialogProgress][1] == 2)
				{
				    PlayerInfo[playerid][pDialogProgress][1] = 1;

					new string[512];
					new number = 0;
					strmid(string, ""#C_RED"> "#C_WHITE"음악 추가\n \n"#C_GRAY"Number\tTitle"#C_WHITE"", 0, 100, 100);

					for(new i = 0; i < MAX_MP3; i ++)
					{
					    if(playerMP3_Create[playerid][i] == 1)
						{
						    format(string, sizeof(string), "%s\n%d\t\t%s", string, i+1, playerMP3_Title[playerid][i]);
						    PlayerInfo[playerid][pTempMP3Indexs][number] = i;
							number ++;
						}
					}
                    ShowPlayerDialog(playerid, DIALOG_MP3, DIALOG_STYLE_LIST, "라이브러리", string, "확인", "이전");
				}
				else if(PlayerInfo[playerid][pDialogProgress][1] == 3)
				{
				    PlayerInfo[playerid][pDialogProgress][1] = 2;
					ShowPlayerDialog(playerid, DIALOG_MP3, DIALOG_STYLE_INPUT, "라이브러리 음악 추가", ""#C_WHITE"라이브러리에 추가할 음악의 URL을 입력해주세요.", "확인", "이전");
				}
				else if(PlayerInfo[playerid][pDialogProgress][1] == 4)
				{
				    PlayerInfo[playerid][pDialogProgress][1] = 1;

					new string[512];
					new number = 0;
					strmid(string, ""#C_RED"> "#C_WHITE"음악 추가\n \n"#C_GRAY"Number\tTitle"#C_WHITE"", 0, 100, 100);

					for(new i = 0; i < MAX_MP3; i ++)
					{
					    if(playerMP3_Create[playerid][i] == 1)
						{
						    format(string, sizeof(string), "%s\n%d\t\t%s", string, i+1, playerMP3_Title[playerid][i]);
							PlayerInfo[playerid][pTempMP3Indexs][number] = i;
							number ++;
						}
					}
                    ShowPlayerDialog(playerid, DIALOG_MP3, DIALOG_STYLE_LIST, "라이브러리", string, "확인", "이전");
				}
				else if(PlayerInfo[playerid][pDialogProgress][1] == 5)
				{
				    PlayerInfo[playerid][pDialogProgress][1] = 4;

				    ShowPlayerDialog(playerid, DIALOG_MP3, DIALOG_STYLE_LIST, "라이브러리", DialogListStyle("음악재생\n제목변경\n제거"), "확인", "이전");
				}
		    }
		    return 1;
		}
		case DIALOG_BANK_CRE:
		{
		    if(response)
		    {
		        if(PlayerInfo[playerid][pDialogProgress][0] == 0)
		        {
		            PlayerInfo[playerid][pDialogProgress][0] = 1;
		            
		            PlayerInfo[playerid][pTempAccountNum] = getAccountNumber();
		            
		            new string[550];
		            format(string, sizeof(string), ""#C_WHITE"Bank of America를 이용해주셔서 감사합니다.\n\
													새로운 계좌와 Debit 카드를 사용하기 전에 다음 사항을 주의 깊게 읽어주십시오.\n\n\
													# 은행과 ATM의 입금, 출금, 송금 등 모든 서비스는 1$ 이상의 단위로 가능합니다.\n\
													# ATM을 사용할 때는 1$ 의 수수료를 지불해야 합니다.\n");
					format(string, sizeof(string), "%s# 당좌 예금 계좌는 이자가 붙지 않습니다.\n\
													# 결제 방식에서 Debit 카드를 선택하면 물건을 구입할 때 현금 대신 계좌의 돈이 빠져나갑니다.\n\n\
													당신의 새로운 계좌번호는 [%d]입니다.", string, PlayerInfo[playerid][pTempAccountNum]);
		            
		            ShowPlayerDialog(playerid, DIALOG_BANK_CRE, DIALOG_STYLE_MSGBOX, "계좌 확인", string, "확인", "");
				}
				else if(PlayerInfo[playerid][pDialogProgress][0] == 1)
				{
				    PlayerInfo[playerid][pDialogProgress][0] = 0;
				    
				    if(IsItemHaveState(playerid, 2004) == 0)
			        {
						if(PlayerInfo[playerid][pMoney] >= BANK_CRE_PRICE)
						{
				            PlayerItemAdd(playerid, 2004, 1);
				            PlayerInfo[playerid][pAccountNum] = PlayerInfo[playerid][pTempAccountNum];
                            GivePlayerMoneyEx(playerid, -BANK_CRE_PRICE);
				            PlayerInfo[playerid][pAccountMoney] = 0;

				            SendMessage(playerid, "보통예금 계좌 개설이 완료되었습니다.");
						}
						else SendErrorMessage(playerid, MessageText[10]);
			        }
			        else SendErrorMessage(playerid, "이미 보통예금이 있습니다.");
				}
		    }
		    else
		    {
		        if(PlayerInfo[playerid][pDialogProgress][0] == 1)
		        {
		            PlayerInfo[playerid][pDialogProgress][0] = 0;
		        }
		    }
		    return 1;
		}
		case DIALOG_BANK:
		{
		    if(IsItemHaveState(playerid, 2004) == 0)
		    {
		        PlayerInfo[playerid][pDialogProgress][0] = 0;
		        PlayerInfo[playerid][pDialogProgress][1] = 0;
		        PlayerInfo[playerid][pDialogProgress][2] = 0;
		        PlayerInfo[playerid][pDialogProgress][3] = 0;
		        
		        SendErrorMessage(playerid, "당신은 보통예금 계좌가 없습니다.");
		        return 1;
		    }
		    if(response)
		    {
		        if(PlayerInfo[playerid][pDialogProgress][0] == 1)
		        {
		            PlayerInfo[playerid][pDialogProgress][0] = 0;
		        }
		        else if(PlayerInfo[playerid][pDialogProgress][1] == 1)
		    	{
					if(strlen(inputtext))
					{
					    new money = strval(inputtext);
					    
					    if(PlayerInfo[playerid][pMoney] >= money)
					    {
					        PlayerInfo[playerid][pAccountMoney] += money;
					        GivePlayerMoneyEx(playerid, -money);
					        
					        SendMessage(playerid, "입금이 완료 되었습니다.");
					        PlayerInfo[playerid][pDialogProgress][1] = 0;
					        return 1;
					    }
					    else SendErrorMessage(playerid, "소지하고 계신 금액보다 많은 금액입니다.");
					}
					else SendErrorMessage(playerid, "다시 작성해주세요.");
                    PlayerInfo[playerid][pDialogProgress][1] = 1;

		            new string[128];
		            format(string, sizeof(string), ""#C_WHITE"입금하실 금액을 입력해주세요.\n\n현재 통장 잔액 : %d", PlayerInfo[playerid][pAccountMoney]);

		            ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_INPUT, "입금", string, "확인", "이전");
			    }
			    else if(PlayerInfo[playerid][pDialogProgress][2] == 1)
		    	{
					if(strlen(inputtext))
					{
					    new money = strval(inputtext);

					    if(PlayerInfo[playerid][pAccountMoney] >= money)
					    {
					        PlayerInfo[playerid][pAccountMoney] -= money;
					        GivePlayerMoneyEx(playerid, money);

					        SendMessage(playerid, "출금이 완료 되었습니다.");
					        PlayerInfo[playerid][pDialogProgress][2] = 0;
					        return 1;
					    }
					    else SendErrorMessage(playerid, "보통예금 계좌에 있는 잔액보다 많은 금액입니다.");
					}
					else SendErrorMessage(playerid, "다시 작성해주세요.");
                    PlayerInfo[playerid][pDialogProgress][2] = 1;

		            new string[128];
		            format(string, sizeof(string), ""#C_WHITE"츨금하실 금액을 입력해주세요.\n\n현재 통장 잔액 : $%d", PlayerInfo[playerid][pAccountMoney]);

		            ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_INPUT, "출금", string, "확인", "이전");
			    }
			    else if(PlayerInfo[playerid][pDialogProgress][3] == 1)
			    {
			        if(strlen(inputtext))
					{
					    PlayerInfo[playerid][pTempAccountNum] = strval(inputtext);
					
					    PlayerInfo[playerid][pDialogProgress][3] = 2;
					    
					    new string[128];
			            format(string, sizeof(string), ""#C_WHITE"송금할 금액을 입력해주세요\n현재 통장 잔액 : $%d\n보낼 계좌번호 : %d", PlayerInfo[playerid][pAccountMoney], PlayerInfo[playerid][pTempAccountNum]);

			            ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_INPUT, "송금", string, "확인", "이전");
					}
					else
					{
					    PlayerInfo[playerid][pDialogProgress][3] = 1;

			            new string[128];
			            format(string, sizeof(string), ""#C_WHITE"송금하실 계좌번호를 입력해주세요.");

			            ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_INPUT, "송금", string, "확인", "이전");
			            
			            SendErrorMessage(playerid, "다시 입력해주세요.");
					}
			    }
			    else if(PlayerInfo[playerid][pDialogProgress][3] == 2)
			    {
			        if(strlen(inputtext))
					{
					    new result = playerRemittance(playerid, PlayerInfo[playerid][pTempAccountNum], strval(inputtext));
					    
						if(result == 1)
						{
						    PlayerInfo[playerid][pDialogProgress][3] = 0;
							SendMessage(playerid, "송금이 완료 되었습니다.");
						}
						else if(result == 0)
						{
						    PlayerInfo[playerid][pDialogProgress][3] = 1;

				            new string[128];
				            format(string, sizeof(string), ""#C_WHITE"송금하실 계좌번호를 입력해주세요.");

				            ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_INPUT, "송금", string, "확인", "이전");
				            
				            SendErrorMessage(playerid, "존재하지 않는 계좌번호 입니다.");
						}
						else if(result == -1)
						{
						    PlayerInfo[playerid][pDialogProgress][3] = 2;

						    new string[128];
				            format(string, sizeof(string), ""#C_WHITE"송금할 금액을 입력해주세요\n현재 통장 잔액 : $%d\n보낼 계좌번호 : %d", PlayerInfo[playerid][pAccountMoney], PlayerInfo[playerid][pTempAccountNum]);

				            ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_INPUT, "송금", string, "확인", "이전");

				            SendErrorMessage(playerid, "보통예금 계좌에 있는 잔액보다 많은 금액입니다.");
						}
					}
					else
					{
					    PlayerInfo[playerid][pDialogProgress][3] = 2;

					    new string[128];
			            format(string, sizeof(string), ""#C_WHITE"송금할 금액을 입력해주세요\n현재 통장 잔액 : $%d\n보낼 계좌번호 : %d", PlayerInfo[playerid][pAccountMoney], PlayerInfo[playerid][pTempAccountNum]);

			            ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_INPUT, "송금", string, "확인", "이전");
			            
			            SendErrorMessage(playerid, "다시 입력해주세요.");
					}
			    }
		        else
			 	{
			        if(listitem == 0) // 계좌 정보 확인
			        {
			            PlayerInfo[playerid][pDialogProgress][0] = 1;

						new string[300];
						format(string, sizeof(string), ""#C_WHITE"____________________\n\
	    	   												     소유자 이름 : %s\n\
																 계좌 번호 : %d\n\
	                                                             잔액 : %d\n\
																 _____________________",
																 PlayerNameEx(playerid), PlayerInfo[playerid][pAccountNum], PlayerInfo[playerid][pAccountMoney]);

			            ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_MSGBOX, "계좌 정보 확인", string, "확인", "이전");
			        }
					if(listitem == 1) // 입금
			        {
			            PlayerInfo[playerid][pDialogProgress][1] = 1;
			            
			            new string[128];
			            format(string, sizeof(string), ""#C_WHITE"입금하실 금액을 입력해주세요.\n\n현재 통장 잔액 : %d", PlayerInfo[playerid][pAccountMoney]);
			            
			            ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_INPUT, "입금", string, "확인", "이전");
			        }
					if(listitem == 2) // 출금
			        {
			            PlayerInfo[playerid][pDialogProgress][2] = 1;

			            new string[128];
			            format(string, sizeof(string), ""#C_WHITE"출금하실 금액을 입력해주세요.\n\n현재 통장 잔액 : %d", PlayerInfo[playerid][pAccountMoney]);

			            ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_INPUT, "출금", string, "확인", "이전");
					}
					if(listitem == 3) // 송금
			        {
			            PlayerInfo[playerid][pDialogProgress][3] = 1;
			            
			            new string[128];
			            format(string, sizeof(string), ""#C_WHITE"송금하실 계좌번호를 입력해주세요.");

			            ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_INPUT, "송금", string, "확인", "이전");
			        }
				}
		    }
		    else
		    {
		        if(PlayerInfo[playerid][pDialogProgress][0] == 1 || PlayerInfo[playerid][pDialogProgress][1] == 1 || PlayerInfo[playerid][pDialogProgress][2] == 1 || PlayerInfo[playerid][pDialogProgress][3] == 1)
		        {
                    PlayerInfo[playerid][pDialogProgress][0] = 0;
			        PlayerInfo[playerid][pDialogProgress][1] = 0;
			        PlayerInfo[playerid][pDialogProgress][2] = 0;
			        PlayerInfo[playerid][pDialogProgress][3] = 0;

			        ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_LIST, "계좌 관리 창구", DialogListStyle("계좌 정보 조회\n입금\n출금\n송금"), "계설신청", "취소");
		        }
		        else if(PlayerInfo[playerid][pDialogProgress][3] == 2)
		        {
		            PlayerInfo[playerid][pDialogProgress][3] = 1;

		            new string[128];
		            format(string, sizeof(string), ""#C_WHITE"송금하실 계좌번호를 입력해주세요.");

		            ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_INPUT, "송금", string, "확인", "이전");
		        }
		    }
		    return 1;
		}
		case DIALOG_ATM_EDIT:
		{
		    if(response)
		    {
				if(PlayerInfo[playerid][pDialogProgress][1] == 1)
				{
				    PlayerInfo[playerid][pDialogProgress][1] = 2;
				    
				    PlayerInfo[playerid][pATMIndex] = PlayerInfo[playerid][pATMIndexs][listitem];
				    
				    ShowPlayerDialog(playerid, DIALOG_ATM_EDIT, DIALOG_STYLE_LIST, "ATM 편집", DialogListStyle("ATM 텔레포트\nATM 위치 변경"), "확인", "취소");
				}
				else if(PlayerInfo[playerid][pDialogProgress][1] == 2)
				{
				    new index = PlayerInfo[playerid][pATMIndex];
				    if(listitem == 0)
				    {
				        if(ATMInfo[index][atm_create] == 1)
				        {
				            SetPlayerPosEx(playerid, ATMInfo[index][atm_pickupPos][0], ATMInfo[index][atm_pickupPos][1], ATMInfo[index][atm_pickupPos][2], 0.0, ATMInfo[index][atm_interior], ATMInfo[index][atm_virtualworld]);
				            
				            new string[128];
				            format(string, sizeof(string), "ATM 위치로 이동 하였습니다. [Interior : %d VirtualWorld : %d]", ATMInfo[index][atm_interior], ATMInfo[index][atm_virtualworld]);
				            SendMessage(playerid, string);
				        }
				        else SendErrorMessage(playerid, "존재하지 않는 ATM 번호 입니다.");
				    }
					if(listitem == 1)
					{
					    if(ATMInfo[index][atm_create] == 1)
				        {

				        }
					}
					PlayerInfo[playerid][pDialogProgress][0] = 0;
					PlayerInfo[playerid][pDialogProgress][1] = 0;
				}
				else
				{
					if(listitem == 0)
					{
					    if(PlayerInfo[playerid][pATMCreMode] == 0)
					    {
	                        PlayerInfo[playerid][pATMCreMode] = 1;

		                    new Float:pos[3], Float:angle;

		                    GetPlayerFrontPos(playerid, pos[0], pos[1], pos[2], 2.0);
		                    GetPlayerFacingAngle(playerid, angle);

		                    PlayerInfo[playerid][pObjectEdit][1] = CreateDynamicObject(2942, pos[0], pos[1], pos[2]-0.4, 0, 0, angle, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), playerid);
		                    EditDynamicObject(playerid, PlayerInfo[playerid][pObjectEdit][1]);
						}
						else SendErrorMessage(playerid, "이미 ATM 제작 모드를 활성화 시켰습니다.");
					}
					if(listitem == 1)
					{
					    PlayerInfo[playerid][pDialogProgress][1] = 1;

						new string[512];
					    new number = 0;

					    for(new i = 0; i < MAX_ATM; i ++)
					    {
					        if(ATMInfo[i][atm_create] == 1)
					        {
					            if(!strlen(string)) { format(string, sizeof(string), "%d\t%.4f,%.4f,%.4f", ATMInfo[i][atm_index], ATMInfo[i][atm_position][0], ATMInfo[i][atm_position][1], ATMInfo[i][atm_position][2]); continue; }
					            format(string, sizeof(string), "%s\n%d\t%.4f,%.4f,%.4f", string, ATMInfo[i][atm_index], ATMInfo[i][atm_position][0], ATMInfo[i][atm_position][1], ATMInfo[i][atm_position][2]);
					            
					            PlayerInfo[playerid][pATMIndexs][number] = i;
					            number ++;
					        }
					    }
					    ShowPlayerDialog(playerid, DIALOG_ATM_EDIT, DIALOG_STYLE_TABLIST, "ATM 목록", string, "확인", "취소");
					}
				}
		    }
		    else
		    {
				if(PlayerInfo[playerid][pDialogProgress][0] == 1 || PlayerInfo[playerid][pDialogProgress][1] == 1)
				{
				    PlayerInfo[playerid][pDialogProgress][0] = 0;
					PlayerInfo[playerid][pDialogProgress][1] = 0;
		
				    ShowPlayerDialog(playerid, DIALOG_ATM_EDIT, DIALOG_STYLE_LIST, "ATM 관리", DialogListStyle("ATM 생성\nATM 목록"), "확인", "취소");
				}
				else if(PlayerInfo[playerid][pDialogProgress][1] == 2)
				{
				    PlayerInfo[playerid][pDialogProgress][1] = 1;

					new string[512];
				    new number = 0;

				    for(new i = 0; i < MAX_ATM; i ++)
				    {
				        if(ATMInfo[i][atm_create] == 1)
				        {
				            if(!strlen(string)) { format(string, sizeof(string), "%d\t%.4f,%.4f,%.4f", ATMInfo[i][atm_index], ATMInfo[i][atm_position][0], ATMInfo[i][atm_position][1], ATMInfo[i][atm_position][2]); continue; }
				            format(string, sizeof(string), "%s\n%d\t%.4f,%.4f,%.4f", string, ATMInfo[i][atm_index], ATMInfo[i][atm_position][0], ATMInfo[i][atm_position][1], ATMInfo[i][atm_position][2]);

				            PlayerInfo[playerid][pATMIndexs][number] = i;
				            number ++;
				        }
				    }
				    ShowPlayerDialog(playerid, DIALOG_ATM_EDIT, DIALOG_STYLE_TABLIST, "ATM 목록", string, "확인", "취소");
				}
		    }
		    return 1;
		}
		case DIALOG_VEHICLE_SHOP:
		{
		    if(listitem == 0)
		    {
		        if(IsItemHaveNum(playerid, 1002) >= 10) return SendErrorMessage(playerid, MessageText[12]);
		        /*if(PlayerInfo[playerid][pShopMode] == 1)
		        {
		            PlayerInfo[playerid][pShopMode] = 0;
		        }
		        */
		        PlayerInfo[playerid][pShopMode] = 1;
		        SetPlayerVirtualWorldEx(playerid, playerid + 1);
		        SetPlayerInteriorEx(playerid, playerid + 1);
		        new ve = CreateVehicle(451,1301.8271,-1313.6812,13.7075,218.8194,1,1,-1);
          		SetVehicleVirtualWorld(ve, playerid + 1);
          		
				PlayerInfo[playerid][pTempBuyVehicleIndex] = 0;
				
				new string[20];
				format(string, sizeof(string), "%d$", integer_comma(vehicleSellInfo[PlayerInfo[playerid][pTempBuyVehicleIndex]][vSell_Price]));
				TextDrawSetString(VehBuyTD[playerid][9], string);
				for(new i = 0; i > MAX_VEH_BUY_TD; i ++)
				{
					TextDrawShowForPlayer(playerid, VehBuyTD[playerid][i]);
				}
				
				//PlayerInfo[playerid][pTempBuyVehicleID]
		    }
			else if(listitem == 1)
			{
			}
		    return 1;
		}
	}
	return 1;
}

stock integer_comma(number)
{
	new str[50];
	format(str, sizeof(str), "%d", number);
	
	new a=0;
	for(new i = strlen(str); i > 0; i --)
	{
	    if(a == 3)
	    {
	        strins(str, ",", i);
	        a = 0;
	    }
	    a ++;
	}
	return str;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(PlayerInfo[playerid][pATMCreMode] == 1)
	{
	    switch(response)
	    {
	        case EDIT_RESPONSE_CANCEL:
	        {
	            PlayerInfo[playerid][pATMCreMode] = 0;
	            DeleteDynamicObjectEx(PlayerInfo[playerid][pObjectEdit][1]);
	            PlayerInfo[playerid][pObjectEdit][1] = -1;
	            
	            SendMessage(playerid, "ATM 생성을 취소 하셨습니다.");
	        }
	        case EDIT_RESPONSE_FINAL:
	        {
	            if(objectid == PlayerInfo[playerid][pObjectEdit][1])
	            {
		            PlayerInfo[playerid][pATMCreMode] = 0;

		            new result = atmDatabaseGenerate(2942, x, y, z, rx, ry, rz, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
		            if(result == 1)
		            {
		                new string[128];
		                format(string, sizeof(string), "어드민 %s님이 ATM을 생성하셨습니다.", PlayerInfo[playerid][pAdminName]);
		                SendAdminMessage(string);
		            }
		            else if(result == 0)
		            {
						SendErrorMessage(playerid, "더 이상 ATM기를 생성할 수 없습니다.");
		            }
		            DeleteDynamicObjectEx(PlayerInfo[playerid][pObjectEdit][1]);
				}
				else
				{
				    DeleteDynamicObjectEx(PlayerInfo[playerid][pObjectEdit][1]);
				    SendErrorMessage(playerid, "알 수 없는 오류로 오브젝트 편집 모드가 취소되었습니다.");
				}
	        }
	    }
	    return 1;
	}
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == Text:INVALID_TEXT_DRAW)
	{
		if(PlayerInfo[playerid][pRegInfoClick] == true)
		{
		    SelectTextDraw(playerid, 0x000000FF);
		}
		if(PlayerInfo[playerid][pInventoryMode] == true)
		{
		    InventoryMode(playerid, false);
		}
		if(PlayerInfo[playerid][pPhoneSelChk] == true)
		{
		    PlayerInfo[playerid][pPhoneSelChk] = false;
		}
		return 1;
	}
	if(PlayerInfo[playerid][pRegInfoClick] == true)
	{
	    new index = PlayerInfo[playerid][pPlayerActorIndex];
	    new string[52];
	    
	    if(clickedid == RegInfoTD[playerid][12]) // country select
	    {
	        ShowContinent(playerid);
	    }
	    
	    if(clickedid == RegInfoTD[playerid][21]) // day left
	    {
	        if(PlayerInfo[playerid][pBornDay] == 1)
	        {
		        PlayerInfo[playerid][pBornDay] = 31;
				format(string, sizeof(string), "%02.d", PlayerInfo[playerid][pBornDay]);
				TextDrawSetString(RegInfoTD[playerid][10], string);
			}
			else
			{
			    PlayerInfo[playerid][pBornDay] --;
				format(string, sizeof(string), "%02.d", PlayerInfo[playerid][pBornDay]);
				TextDrawSetString(RegInfoTD[playerid][10], string);
			}
	    }
	    
	    if(clickedid == RegInfoTD[playerid][22]) // day right
	    {
	        if(PlayerInfo[playerid][pBornDay] == 31)
	        {
		        PlayerInfo[playerid][pBornDay] = 1;
				format(string, sizeof(string), "%02.d", PlayerInfo[playerid][pBornDay]);
				TextDrawSetString(RegInfoTD[playerid][10], string);
			}
			else
			{
			    PlayerInfo[playerid][pBornDay] ++;
				format(string, sizeof(string), "%02.d", PlayerInfo[playerid][pBornDay]);
				TextDrawSetString(RegInfoTD[playerid][10], string);
			}
	    }
	    
	    if(clickedid == RegInfoTD[playerid][19]) // month left
	    {
	        if(PlayerInfo[playerid][pBornMonth] == 1)
	        {
	            PlayerInfo[playerid][pBornMonth] = 12;
				format(string, sizeof(string), "%02.d", PlayerInfo[playerid][pBornMonth]);
				TextDrawSetString(RegInfoTD[playerid][8], string);
	        }
	        else
	        {
	            PlayerInfo[playerid][pBornMonth]--;
				format(string, sizeof(string), "%02.d", PlayerInfo[playerid][pBornMonth]);
				TextDrawSetString(RegInfoTD[playerid][8], string);
	        }
	    }
	    
	    if(clickedid == RegInfoTD[playerid][20]) // month right
	    {
	        if(PlayerInfo[playerid][pBornMonth] == 12)
	        {
	            PlayerInfo[playerid][pBornMonth] = 1;
				format(string, sizeof(string), "%02.d", PlayerInfo[playerid][pBornMonth]);
				TextDrawSetString(RegInfoTD[playerid][8], string);
	        }
	        else
	        {
	            PlayerInfo[playerid][pBornMonth]++;
				format(string, sizeof(string), "%02.d", PlayerInfo[playerid][pBornMonth]);
				TextDrawSetString(RegInfoTD[playerid][8], string);
	        }
	    }
	    
	    if(clickedid == RegInfoTD[playerid][17]) // year left
	    {
	        if(PlayerInfo[playerid][pBornYear] == START_YEAR)
	        {
	            PlayerInfo[playerid][pBornYear] = END_YEAR;
	            format(string, sizeof(string), "%d", PlayerInfo[playerid][pBornYear]);
				TextDrawSetString(RegInfoTD[playerid][7], string);
	        }
	        else
	        {
	            PlayerInfo[playerid][pBornYear]--;
	            format(string, sizeof(string), "%d", PlayerInfo[playerid][pBornYear]);
				TextDrawSetString(RegInfoTD[playerid][7], string);
	        }
	    }
	    
	    if(clickedid == RegInfoTD[playerid][18]) // year right
	    {
	        if(PlayerInfo[playerid][pBornYear] == END_YEAR)
	        {
	            PlayerInfo[playerid][pBornYear] = START_YEAR;
	            format(string, sizeof(string), "%d", PlayerInfo[playerid][pBornYear]);
				TextDrawSetString(RegInfoTD[playerid][7], string);
	        }
	        else
	        {
	            PlayerInfo[playerid][pBornYear]++;
	            format(string, sizeof(string), "%d", PlayerInfo[playerid][pBornYear]);
				TextDrawSetString(RegInfoTD[playerid][7], string);
	        }
	    }
	    
	    if(clickedid == RegInfoTD[playerid][15]) // gender left
	    {
	        if(PlayerInfo[playerid][pSex] == 0 || PlayerInfo[playerid][pSex] == 1) return 0;
	        else if(PlayerInfo[playerid][pSex] == 2)
	        {
	            format(string, sizeof(string), "man");
    			TextDrawSetString(RegInfoTD[playerid][6], string);
    			PlayerInfo[playerid][pSex] = 1;
    			
    			DestroyActor(PlayerInfo[playerid][pPlayerActor]);
			    PlayerInfo[playerid][pPlayerActor] = CreateActor(DefaultSkin[PlayerInfo[playerid][pSex]-1][0], 1958.2168, 1172.1118, 1146.4017, 22.9102);
			    SetActorVirtualWorld(PlayerInfo[playerid][pPlayerActor], playerid+1);
			    PlayerInfo[playerid][pPlayerActorSkin] = DefaultSkin[PlayerInfo[playerid][pSex]-1][0];
			    PlayerInfo[playerid][pPlayerActorIndex] = 0;
			    format(string, sizeof(string), "%d", DefaultSkin[PlayerInfo[playerid][pSex]-1][0]);
			    TextDrawSetString(RegInfoTD[playerid][24], string);
	        }
	    }
	    
	    if(clickedid == RegInfoTD[playerid][16]) // gender right
	    {
	        if(PlayerInfo[playerid][pSex] == 0 || PlayerInfo[playerid][pSex] == 2) return 0;
	        else if(PlayerInfo[playerid][pSex] == 1)
	        {
	            format(string, sizeof(string), "woman");
            	TextDrawSetString(RegInfoTD[playerid][6], string);
            	PlayerInfo[playerid][pSex] = 2;
            	
            	DestroyActor(PlayerInfo[playerid][pPlayerActor]);
			    PlayerInfo[playerid][pPlayerActor] = CreateActor(DefaultSkin[PlayerInfo[playerid][pSex]-1][0], 1958.2168, 1172.1118, 1146.4017, 22.9102);
			    SetActorVirtualWorld(PlayerInfo[playerid][pPlayerActor], playerid+1);
			    PlayerInfo[playerid][pPlayerActorSkin] = DefaultSkin[PlayerInfo[playerid][pSex]-1][0];
			    PlayerInfo[playerid][pPlayerActorIndex] = 0;
			    format(string, sizeof(string), "%d", DefaultSkin[PlayerInfo[playerid][pSex]-1][0]);
			    TextDrawSetString(RegInfoTD[playerid][24], string);
	        }
	    }
	    
	    if(clickedid == RegInfoTD[playerid][25]) // skin left
	    {
	        if(PlayerInfo[playerid][pSex] == 0) return 0;
	        if(PlayerInfo[playerid][pPlayerActorSkin] == DefaultSkin[PlayerInfo[playerid][pSex]-1][0]) return 0;
	        DestroyActor(PlayerInfo[playerid][pPlayerActor]);
            PlayerInfo[playerid][pPlayerActor] = CreateActor(DefaultSkin[PlayerInfo[playerid][pSex]-1][index-1], 1958.2168, 1172.1118, 1146.4017, 22.9102);
            SetActorVirtualWorld(PlayerInfo[playerid][pPlayerActor], playerid+1);
            PlayerInfo[playerid][pPlayerActorSkin] = DefaultSkin[PlayerInfo[playerid][pSex]-1][index-1];
            PlayerInfo[playerid][pPlayerActorIndex] = index-1;
            format(string, sizeof(string), "%d", DefaultSkin[PlayerInfo[playerid][pSex]-1][index-1]);
            TextDrawSetString(RegInfoTD[playerid][24], string);
	    }
	    if(clickedid == RegInfoTD[playerid][26]) // skin right
	    {
	        if(PlayerInfo[playerid][pSex] == 0) return 0;
	        if(PlayerInfo[playerid][pPlayerActorSkin] == DefaultSkin[PlayerInfo[playerid][pSex]-1][sizeof(DefaultSkin[])-1]) return 0;
	        DestroyActor(PlayerInfo[playerid][pPlayerActor]);
            PlayerInfo[playerid][pPlayerActor] = CreateActor(DefaultSkin[PlayerInfo[playerid][pSex]-1][index+1], 1958.2168, 1172.1118, 1146.4017, 22.9102);
            SetActorVirtualWorld(PlayerInfo[playerid][pPlayerActor], playerid+1);
            PlayerInfo[playerid][pPlayerActorSkin] = DefaultSkin[PlayerInfo[playerid][pSex]-1][index+1];
            PlayerInfo[playerid][pPlayerActorIndex] = index+1;
            format(string, sizeof(string), "%d", DefaultSkin[PlayerInfo[playerid][pSex]-1][index+1]);
            TextDrawSetString(RegInfoTD[playerid][24], string);
	    }
	    if(clickedid == RegInfoTD[playerid][13]) // select
	    {
	        if(PlayerInfo[playerid][pCountry] == 0) return ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, "Error Message", ""#C_WHITE"국가를 선택해주세요.", "확인", "");
	        
	        DestroyActor(PlayerInfo[playerid][pPlayerActor]);
	        PlayerInfo[playerid][pRegInfoClick] = false;
	        TogglePlayerControllable(playerid, false);
	        
	        PlayerInfo[playerid][pTutScreen] 	= 0;
	        PlayerInfo[playerid][pTutorial] 	= 1;
	        PlayerInfo[playerid][pSkin]         = PlayerInfo[playerid][pPlayerActorSkin];

         	SetTimerEx("ScreenStart", 100, false, "dd", playerid, 1);
	        
	        for(new i = 0; i < MAX_REGTD; i ++)
	        {
		        TextDrawHideForPlayer(playerid, RegInfoTD[playerid][i]);
			}
	        CancelSelectTextDraw(playerid);
	        
	        OnPlayerSave(playerid, 1);
	    }
	    if(clickedid == RegInfoTD[playerid][14]) // cancel
	    {
	        /***
	        PlayerInfo[playerid][pRegInfoClick] = false;
	        DestroyActor(PlayerInfo[playerid][pPlayerActor]);
	        TogglePlayerControllable(playerid, false);
	        TogglePlayerSpectating(playerid, false);
	        SetPlayerPosEx(playerid, 0, 0, 0, 0, 0, 0);
	        SetCameraBehindPlayer(playerid);
	        ***/
	    
	        for(new i = 0; i < MAX_REGTD; i ++)
	        {
		        TextDrawHideForPlayer(playerid, RegInfoTD[playerid][i]);
			}
			CancelSelectTextDraw(playerid);
	        KickEx(playerid, 1);
	    }
	    return 1;
	}
    if(PlayerInfo[playerid][pInventoryMode] == true)
	{
		if(clickedid == InventoryTD[playerid][30])
		{
		    InventoryMode(playerid, false);
		    return 1;
		}
		new itemclick = 0;
		for(new i = START_INVEN; i < END_INVEN; i ++)
		{
			if(clickedid == InventoryTD[playerid][i])
			{
			    if(PlayerInfo[playerid][pItemDisPlace][0] != -1)
			    {
			        PlayerInfo[playerid][pItemDisPlace][1] = i;
			        
					new item[2][2];
					item[0][0] = InvenItem[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemDisPlace][0]-START_INVEN];
					item[0][1] = InvenItemNum[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemDisPlace][0]-START_INVEN];
					item[1][0] = InvenItem[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemDisPlace][1]-START_INVEN];
					item[1][1] = InvenItemNum[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemDisPlace][1]-START_INVEN];
					
					InvenItem[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemDisPlace][0]-START_INVEN] = item[1][0];
					InvenItemNum[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemDisPlace][0]-START_INVEN] = item[1][1];
					InvenItem[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemDisPlace][1]-START_INVEN] = item[0][0];
					InvenItemNum[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemDisPlace][1]-START_INVEN] = item[0][1];
					
					PlayerInfo[playerid][pItemDisPlace][0] = -1;
	        		PlayerInfo[playerid][pItemDisPlace][1] = -1;
	        
					PlayerItemUpdate(playerid);
			        return 1;
			    }
			    itemclick = 1;
			    
				PlayerInfo[playerid][pItemClick] = i - START_INVEN;
				if(InvenItem[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemClick]] > 0 && InvenItemNum[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemClick]] > 0)
				{
                    PlayerInfo[playerid][pInventoryMode] = false;
				
					CancelSelectTextDraw(playerid);

					new str[100];
	                format(str, sizeof(str), "%s(%d개)", GetItemName(InvenItem[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemClick]]), InvenItemNum[playerid][InvenSelectSlot[playerid]][PlayerInfo[playerid][pItemClick]]);
	                ShowPlayerDialog(playerid, DIALOG_ITEM_CLICK, DIALOG_STYLE_LIST, str, DialogListStyle("사용하기\n주기\n자리이동\n버리기"), "확인", "취소");
				}
				else itemclick = -1;
			    return 1;
			}
		}
		if(itemclick == 0)
	    {
	        PlayerInfo[playerid][pItemDisPlace][0] = -1;
	        PlayerInfo[playerid][pItemDisPlace][1] = -1;
	    
		    new iconclick = 0, oldiconindex = -1, newiconindex = -1;

		    switch(InvenSelectSlot[playerid])
		    {
		        case 0: oldiconindex = 2;
		        case 1: oldiconindex = 3;
		        case 2: oldiconindex = 4;
		        case 3: oldiconindex = 25;
		        case 4: oldiconindex = 26;
				default : SendErrorMessage(playerid, "모드에 오류가 있습니다. F8로 스크린샷을 찍은 후 관리자에게 문의해주세요.");
		    }
			if(clickedid == InventoryTD[playerid][2]) // 가방 아이콘을 클릭했을 때
			{
			    iconclick = 1;
			    newiconindex = 2;
			    InvenSelectSlot[playerid] = 0;
			}
			if(clickedid == InventoryTD[playerid][3]) // 키 아이콘을 클릭했을 때
			{
			    iconclick = 1;
			    newiconindex = 3;
			    InvenSelectSlot[playerid] = 1;
			}
			if(clickedid == InventoryTD[playerid][4]) // 지갑 아이콘을 클릭했을 때
			{
			    iconclick = 1;
			    newiconindex = 4;
			    InvenSelectSlot[playerid] = 2;
			}
			if(clickedid == InventoryTD[playerid][25]) // 총 아이콘을 선택했을 때
			{
			    iconclick = 1;
			    newiconindex = 25;
			    InvenSelectSlot[playerid] = 3;
			}
			if(clickedid == InventoryTD[playerid][26]) // 휴대전화 아이콘을 선택했을 때
			{
			    iconclick = 1;
			    newiconindex = 26;
			    InvenSelectSlot[playerid] = 4;
			}
			if(iconclick == 1 && oldiconindex >= 0 && newiconindex != oldiconindex)
			{
			    TextDrawColor(InventoryTD[playerid][oldiconindex], COLOR_ICONCOLOR);
				TextDrawShowForPlayer(playerid, InventoryTD[playerid][oldiconindex]);
			}
			if(iconclick == 1 && newiconindex >= 0 && newiconindex != oldiconindex)
			{
			    TextDrawColor(InventoryTD[playerid][newiconindex], COLOR_TDCLICK);
				TextDrawShowForPlayer(playerid, InventoryTD[playerid][newiconindex]);
				PlayerItemUpdate(playerid);
			}
		}
	}
	if(PlayerInfo[playerid][pPhoneSelChk] == true)
	{
		if(IsItemHaveState(playerid, 1) == 1)
	    {
			if(clickedid == PlayerPhoneTD[playerid][2]) // 전화 아이콘
			{
			    if(PlayerInfo[playerid][pCallNum] == -1)
			    {
					for(new a = 2; a < 20; a ++)
					{
					    if(a == TIME_BAR_INDEX) continue;
						TextDrawHideForPlayer(playerid, PlayerPhoneTD[playerid][a]);
					}
					for(new a = 0; a < MAX_NUM_LENGTH; a ++)
						PlayerInfo[playerid][pCallNumText][a] = '\0';
				    TextDrawSetString(PlayerPhoneTD[playerid][35], "");
					PlayerInfo[playerid][pPhoneNumberPad] = 0;
					for(new a = START_CALL_TD; a < END_CALL_TD; a ++)
					{
					    TextDrawShowForPlayer(playerid, PlayerPhoneTD[playerid][a]);
					}
			    }
			    else return SendErrorMessage(playerid, MessageText[8]);
			    return 1;
			}
			if(clickedid == PlayerPhoneTD[playerid][3]) // 메세지 아이콘
			{
				PlayerInfo[playerid][pDialogProgress][0] = 0;
				PlayerInfo[playerid][pDialogProgress][1] = 0;
				PlayerInfo[playerid][pDialogProgress][2] = 0;
			    ShowPlayerDialog(playerid, DIALOG_SMS, DIALOG_STYLE_LIST, "문자메세지", DialogListStyle("문자보내기\n문자수신함\n문자발신함"), "확인", "취소");
			    
			    CancelSelectTextDraw(playerid);
			    PlayerInfo[playerid][pPhoneSelChk] = false;
			    return 1;
			}
			if(clickedid == PlayerPhoneTD[playerid][4]) // 노트 아이콘
			{
			    PlayerInfo[playerid][pDialogProgress][0] = 0;
				PlayerInfo[playerid][pDialogProgress][1] = 0;
				PlayerInfo[playerid][pDialogProgress][2] = 0;
				
				ShowPlayerDialog(playerid, DIALOG_NOTE, DIALOG_STYLE_LIST, "개인노트", DialogListStyle("노트작성\n노트보기\n노트제거"), "확인", "취소");
				
				CancelSelectTextDraw(playerid);
			    PlayerInfo[playerid][pPhoneSelChk] = false;
			    return 1;
			}
			if(clickedid == PlayerPhoneTD[playerid][5]) // 전화번호부 아이콘
			{
			    PlayerInfo[playerid][pDialogProgress][0] = 0;
				PlayerInfo[playerid][pDialogProgress][1] = 0;
				
			    ShowPlayerDialog(playerid, DIALOG_NUM_NOTE, DIALOG_STYLE_LIST, "전화번호부", DialogListStyle("전화번호 등록\n전화번호부"), "확인", "취소");
			    return 1;
			}
			if(clickedid == PlayerPhoneTD[playerid][9]) // mp3 아이콘
			{
			    PlayerInfo[playerid][pDialogProgress][0] = 0;
				PlayerInfo[playerid][pDialogProgress][1] = 0;
			
			    ShowPlayerDialog(playerid, DIALOG_MP3, DIALOG_STYLE_LIST, "MP3", DialogListStyle("음악재생\n라이브러리\n음악정지"), "확인", "취소");
			    return 1;
			}
			new bool:numPadClick = false;
			for(new a = 21; a <= 32; a ++)
			{
				if(clickedid == PlayerPhoneTD[playerid][a])
				{
				    Audio_PlayStreamed(playerid, "http://cfile10.uf.tistory.com/media/275EC73A587E571B0BF283", false, false, false);

				    if(clickedid == PlayerPhoneTD[playerid][30]) return 0;
					if(clickedid == PlayerPhoneTD[playerid][32]) return 0;
				    if(PlayerInfo[playerid][pPhoneNumberPad] >= MAX_NUM_LENGTH) return 0;
				    numPadClick = true;

				    new str[2];
				    format(str, sizeof(str), "%d", a - 20);
				    PlayerInfo[playerid][pCallNumText][PlayerInfo[playerid][pPhoneNumberPad]] = str[0];

	                if(clickedid == PlayerPhoneTD[playerid][31])
				    {
				        PlayerInfo[playerid][pCallNumText][PlayerInfo[playerid][pPhoneNumberPad]] = '0';
				    }

				    TextDrawSetString(PlayerPhoneTD[playerid][35], PlayerInfo[playerid][pCallNumText]);

				    PlayerInfo[playerid][pPhoneNumberPad] ++;
				    return 1;
				}
			}
			if(numPadClick == false)
			{
			    if(PlayerInfo[playerid][pPhoneNumberPad] != 0)
				{
				    if(clickedid == PlayerPhoneTD[playerid][33])
				    {
				        new result = PlayerCall(playerid, strval(PlayerInfo[playerid][pCallNumText]));
						if(result == 1)
						{
					        for(new a = START_CALL_TD; a < END_CALL_TD; a ++)
							{
							    TextDrawHideForPlayer(playerid, PlayerPhoneTD[playerid][a]);
							}

							TextDrawShowForPlayer(playerid, PlayerPhoneTD[playerid][37]);

							PlayerInfo[playerid][pPhoneSelChk] = false;
							CancelSelectTextDraw(playerid);
						}
						else
						{
							PlayerInfo[playerid][pPhoneNumberPad] = 0;
							for(new a = 0; a < MAX_NUM_LENGTH; a ++)
								PlayerInfo[playerid][pCallNumText][a] = '\0';
							TextDrawSetString(PlayerPhoneTD[playerid][35], "");
						}
				    }
				}
				if(clickedid == PlayerPhoneTD[playerid][34])
				{
				    PlayerInfo[playerid][pCallNumText][PlayerInfo[playerid][pPhoneNumberPad]-1] = '\0';
				    TextDrawSetString(PlayerPhoneTD[playerid][35], PlayerInfo[playerid][pCallNumText]);
				    PlayerInfo[playerid][pPhoneNumberPad] --;
				}
			}
		}
		else
		{
		    SendErrorMessage(playerid, MessageText[7]);
		    OnPlayerCommandText(playerid, "/폰 닫기");
		}
	}
    return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	return 1;
}
public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid)
{
	if(IsPlayerLogin(playerid))
	{
    	GivePlayerHealthEx(playerid, -amount);
    	
    	if(PlayerInfo[playerid][pInventoryMode] == true)
	    {
			InventoryMode(playerid, false);
	    }
	    if(PlayerInfo[playerid][pPhoneTDChk] == true)
		{
			PhoneMode(playerid, false);
	    }
    }
	return 1;
}
//========================= forward public =========================//
forward ServerInfo(ServerONCheck);
public ServerInfo(ServerONCheck)
{
    if(ServerONCheck == 1)
	{
		for(new i = 0; i < 50; i ++)
		{
			print(" ");
		}
		return SetTimerEx("ServerInfo", 500, false, "d", 2);
	}
	else if(ServerONCheck == 2)
	{
	    printf("%s - ON", SERVER_NAME);
		if(ServerDBConnect == 1) printf("[INFO] MySQL Connect Success");
		else printf("[ERROR] MySQL Connect Fail");
		if(ObjectLoadCheck == 1) printf("[INFO] Objectload Success");
		else printf("[ERROR] Objectload Fail");
	}
	return 1;
}

forward UnFreeze(playerid);
public UnFreeze(playerid)
{
    TogglePlayerControllable(playerid, true);
}

forward ActorTimer();
public ActorTimer()
{
	for(new a = 0; a < MAX_ACTOR; a ++)
	{
	    if(ActorInfo[a][aCreate] == 1)
	    {
	        if(strlen(ActorInfo[a][aAnimlib]) && strlen(ActorInfo[a][aAnimName]))
	        {
	            ApplyActorAnimation(ActorInfo[a][aID], ActorInfo[a][aAnimlib], ActorInfo[a][aAnimName], 4.1, 0, 0, 0 , 1, 5000);
	        }
	        if(strlen(ActorInfo[a][aName]))
	        {
	            if(strlen(ActorDialogue[a][0]))
	            {
					if(ActorInfo[a][aDiaugueC] == 1)
					{
					    new text[128], maxIndex = 0;
					
					    ActorInfo[a][aDiaugueC] = 0;
					    
			            for(new index = 0; index < MAX_ACTOR_DIALOGUE; index ++) { if(strlen(ActorDialogue[a][index])) { maxIndex++; } }
				                
						new Random = random(maxIndex);
						if(maxIndex != 1 && ActorInfo[a][aDiaugueOverlap] == Random)
						{
						    new loop = 0;
							while(loop != 1)
							{
							    Random = random(maxIndex);
							    if(ActorInfo[a][aDiaugueOverlap] == Random) continue;
                                loop = 1;
							}
						}
						ActorInfo[a][aDiaugueOverlap] = Random;
						
						format(text, sizeof(text), "%s", ActorDialogue[a][Random]);
						strmid(ActorInfo[a][aTextLabel], text, 0, 128, 128);
						
						ActorInfo[a][aTextLabelID2] = Create3DTextLabel(ActorInfo[a][aTextLabel],
																		0xFFFFFFFF,
																		ActorInfo[a][aPosition][0],
																		ActorInfo[a][aPosition][1],
																		ActorInfo[a][aPosition][2]+1.1,
																		10.0,
																		0);
				    }
					else
					{
					    ActorInfo[a][aDiaugueC] = 1;
					    Delete3DTextLabel(ActorInfo[a][aTextLabelID2]);
					}
					
					//strmid(ActorInfo[a][aTextLabel], text, 0, 128, 128);
					//Update3DTextLabelText(ActorInfo[a][aTextLabelID], COLOR_ACTOR, ActorInfo[a][aTextLabel]);
				}
	        }
	    }
	}
}

forward ServerTime();
public ServerTime()
{
	for(new i = 0; i < MAX_PLAYERS; i ++)
	{
	    if(IsPlayerConnected(i) && IsPlayerLogin(i))
	    {
	    	if(PlayerInfo[i][pSaveTime] > 0)
	    	{
	    	    PlayerInfo[i][pSaveTime] --;
	    	    if(PlayerInfo[i][pSaveTime] <= 0)
	    	    {
	    	        PlayerInfo[i][pSaveTime] = 0;
	    	    }
	    	}
		}
	}
	return 1;
}

forward OnPlayerSave(playerid, sort, index = -1);
stock OnPlayerSave(playerid, sort, index = -1)
{
    if(IsPlayerConnected(playerid))
    {
        if(IsPlayerLogin(playerid) && PlayerInfo[playerid][pIsSave] == true)
		{
		    new query[1024];
		    if(sort == 1 || sort == -1)
		    {
			    GetPlayerPos(playerid, PlayerInfo[playerid][pPos][0], PlayerInfo[playerid][pPos][1], PlayerInfo[playerid][pPos][2]);
			    GetPlayerFacingAngle(playerid, PlayerInfo[playerid][pAngle]);
	    		orm_save(PlayerInfo[playerid][ORM_ID]);
	        }
	        if(sort == 2 || sort == -1)
		    {
		        if(index == -1)
		        {
				    for(new i = 0; i < MAX_SMS; i ++)
					{
					    mysql_format(MySQL, query, sizeof(query), "UPDATE `%s` SET", MySQL_SMS);
					    mysql_format(MySQL, query, sizeof(query), "%s `SMSSend_CallNum_%d` = '%d',",query, i, SMSSend_CallNum[playerid][i]);
						mysql_format(MySQL, query, sizeof(query), "%s `SMSSend_Index_%d` = '%d',",query, i, SMSSend_Index[playerid][i]);
						mysql_format(MySQL, query, sizeof(query), "%s `SMSSend_Date_%d` = '%s',",query, i, DateInsert(SMSSend_Year[playerid][i], SMSSend_Month[playerid][i], SMSSend_Day[playerid][i], SMSSend_Hour[playerid][i], SMSSend_Minute[playerid][i], -1));
					    mysql_format(MySQL, query, sizeof(query), "%s `SMSSend_Content_%d` = '%s',",query, i, SMSSend_Content[playerid][i]);

					    mysql_format(MySQL, query, sizeof(query), "%s `SMSReceive_CallNum_%d` = '%d',",query, i, SMSReceive_CallNum[playerid][i]);
					    mysql_format(MySQL, query, sizeof(query), "%s `SMSReceive_HitChk_%d` = '%d',",query, i, SMSReceive_HitChk[playerid][i]);
						mysql_format(MySQL, query, sizeof(query), "%s `SMSReceive_Index_%d` = '%d',",query, i, SMSReceive_Index[playerid][i]);
						mysql_format(MySQL, query, sizeof(query), "%s `SMSReceive_Date_%d` = '%s',",query, i, DateInsert(SMSReceive_Year[playerid][i], SMSReceive_Month[playerid][i], SMSReceive_Day[playerid][i], SMSReceive_Hour[playerid][i], SMSReceive_Minute[playerid][i], -1));
					    mysql_format(MySQL, query, sizeof(query), "%s `SMSReceive_Content_%d` = '%s'",query, i, SMSReceive_Content[playerid][i]);
					    mysql_format(MySQL, query, sizeof(query), "%s WHERE `SMSPhoneNumber` = '%d' LIMIT 1", query, PlayerInfo[playerid][pPhoneNumber]);
					    mysql_tquery(MySQL, query, "", "");
					}
				}
				else
				{
				    new i = index;
				
				    mysql_format(MySQL, query, sizeof(query), "UPDATE `%s` SET", MySQL_SMS);
				    mysql_format(MySQL, query, sizeof(query), "%s `SMSSend_CallNum_%d` = '%d',",query, i, SMSSend_CallNum[playerid][i]);
					mysql_format(MySQL, query, sizeof(query), "%s `SMSSend_Index_%d` = '%d',",query, i, SMSSend_Index[playerid][i]);
					mysql_format(MySQL, query, sizeof(query), "%s `SMSSend_Date_%d` = '%s',",query, i, DateInsert(SMSSend_Year[playerid][i], SMSSend_Month[playerid][i], SMSSend_Day[playerid][i], SMSSend_Hour[playerid][i], SMSSend_Minute[playerid][i], -1));
				    mysql_format(MySQL, query, sizeof(query), "%s `SMSSend_Content_%d` = '%s',",query, i, SMSSend_Content[playerid][i]);

				    mysql_format(MySQL, query, sizeof(query), "%s `SMSReceive_CallNum_%d` = '%d',",query, i, SMSReceive_CallNum[playerid][i]);
				    mysql_format(MySQL, query, sizeof(query), "%s `SMSReceive_HitChk_%d` = '%d',",query, i, SMSReceive_HitChk[playerid][i]);
					mysql_format(MySQL, query, sizeof(query), "%s `SMSReceive_Index_%d` = '%d',",query, i, SMSReceive_Index[playerid][i]);
					mysql_format(MySQL, query, sizeof(query), "%s `SMSReceive_Date_%d` = '%s',",query, i, DateInsert(SMSReceive_Year[playerid][i], SMSReceive_Month[playerid][i], SMSReceive_Day[playerid][i], SMSReceive_Hour[playerid][i], SMSReceive_Minute[playerid][i], -1));
				    mysql_format(MySQL, query, sizeof(query), "%s `SMSReceive_Content_%d` = '%s'",query, i, SMSReceive_Content[playerid][i]);
				    mysql_format(MySQL, query, sizeof(query), "%s WHERE `SMSPhoneNumber` = '%d' LIMIT 1", query, PlayerInfo[playerid][pPhoneNumber]);
				    mysql_tquery(MySQL, query, "", "");
				}
			}
			if(sort == 3 || sort == -1)
		    {
		        if(index == -1)
		        {
			        for(new i = 0; i < MAX_NOTE; i ++)
					{
					    if(privateNote_Create[playerid][i] == 1)
					    {
						    mysql_format(MySQL, query, sizeof(query), "UPDATE `%s` SET", MySQL_NOTE);
						    mysql_format(MySQL, query, sizeof(query), "%s `privateNote_Create` = '%d',",query, privateNote_Create[playerid][i]);
						    mysql_format(MySQL, query, sizeof(query), "%s `privateNote_Index` = '%d',",query, privateNote_Index[playerid][i]);
							mysql_format(MySQL, query, sizeof(query), "%s `privateNote_Date` = '%s',",query, DateInsert(privateNote_Date[playerid][i][0], privateNote_Date[playerid][i][1], privateNote_Date[playerid][i][2], privateNote_Time[playerid][i][0], privateNote_Time[playerid][i][1], -1));
							mysql_format(MySQL, query, sizeof(query), "%s `privateNote_Name` = '%s',",query, privateNote_Name[playerid][i]);
						    mysql_format(MySQL, query, sizeof(query), "%s `privateNote_Content` = '%s'",query, privateNote_Content[playerid][i]);
						    mysql_format(MySQL, query, sizeof(query), "%s WHERE `privateNote_Name` = '%s' AND `privateNote_Index` = '%d' LIMIT 1", query, privateNote_Name[playerid][i], privateNote_Index[playerid][i]);
						    mysql_tquery(MySQL, query, "", "");
						}
					}
				}
				else
				{
				    new i = index;
				    
				    if(privateNote_Create[playerid][i] == 1)
				    {
					    mysql_format(MySQL, query, sizeof(query), "UPDATE `%s` SET", MySQL_NOTE);
					    mysql_format(MySQL, query, sizeof(query), "%s `privateNote_Create` = '%d',",query, privateNote_Create[playerid][i]);
					    mysql_format(MySQL, query, sizeof(query), "%s `privateNote_Index` = '%d',",query, privateNote_Index[playerid][i]);
						mysql_format(MySQL, query, sizeof(query), "%s `privateNote_Date` = '%s',",query, DateInsert(privateNote_Date[playerid][i][0], privateNote_Date[playerid][i][1], privateNote_Date[playerid][i][2], privateNote_Time[playerid][i][0], privateNote_Time[playerid][i][1], -1));
						mysql_format(MySQL, query, sizeof(query), "%s `privateNote_Name` = '%s',",query, privateNote_Name[playerid][i]);
					    mysql_format(MySQL, query, sizeof(query), "%s `privateNote_Content` = '%s'",query, privateNote_Content[playerid][i]);
					    mysql_format(MySQL, query, sizeof(query), "%s WHERE `privateNote_Name` = '%s' AND `privateNote_Index` = '%d' LIMIT 1", query, privateNote_Name[playerid][i], privateNote_Index[playerid][i]);
					    mysql_tquery(MySQL, query, "", "");
					}
				}
			}
			if(sort == 4 || sort == -1)
		    {
		        if(index == -1)
		        {
			        for(new i = 0; i < MAX_NUM_NOTE; i ++)
					{
					    if(NumberNote_Create[playerid][i] == 1)
					    {
					    	mysql_format(MySQL, query, sizeof(query), "UPDATE `%s` SET", MySQL_NUM_NOTE);
						    mysql_format(MySQL, query, sizeof(query), "%s `NumberNote_Create` = '%d',",query, NumberNote_Create[playerid][i]);
						    mysql_format(MySQL, query, sizeof(query), "%s `NumberNote_Index` = '%d',",query, NumberNote_Index[playerid][i]);
							mysql_format(MySQL, query, sizeof(query), "%s `NumberNote_CallNum` = '%d',",query, NumberNote_CallNum[playerid][i]);
							mysql_format(MySQL, query, sizeof(query), "%s `NumberNote_Name` = '%s',",query, NumberNote_Name[playerid][i]);
							mysql_format(MySQL, query, sizeof(query), "%s `NumberNote_NickName` = '%s'",query, NumberNote_NickName[playerid][i]);
						    mysql_format(MySQL, query, sizeof(query), "%s WHERE `NumberNote_Name` = '%s' AND `NumberNote_Index` = '%d' LIMIT 1", query, NumberNote_Name[playerid][i], NumberNote_Index[playerid][i]);
						    mysql_tquery(MySQL, query, "", "");
						}
					}
				}
				else
				{
				    new i = index;
				    
				    if(NumberNote_Create[playerid][i] == 1)
				    {
				    	mysql_format(MySQL, query, sizeof(query), "UPDATE `%s` SET", MySQL_NUM_NOTE);
					    mysql_format(MySQL, query, sizeof(query), "%s `NumberNote_Create` = '%d',",query, NumberNote_Create[playerid][i]);
					    mysql_format(MySQL, query, sizeof(query), "%s `NumberNote_Index` = '%d',",query, NumberNote_Index[playerid][i]);
						mysql_format(MySQL, query, sizeof(query), "%s `NumberNote_CallNum` = '%d',",query, NumberNote_CallNum[playerid][i]);
						mysql_format(MySQL, query, sizeof(query), "%s `NumberNote_Name` = '%s',",query, NumberNote_Name[playerid][i]);
						mysql_format(MySQL, query, sizeof(query), "%s `NumberNote_NickName` = '%s'",query, NumberNote_NickName[playerid][i]);
					    mysql_format(MySQL, query, sizeof(query), "%s WHERE `NumberNote_Name` = '%s' AND `NumberNote_Index` = '%d' LIMIT 1", query, NumberNote_Name[playerid][i], NumberNote_Index[playerid][i]);
					    mysql_tquery(MySQL, query, "", "");
					}
				}
			}
			if(sort == 5 || sort == -1)
			{
			    if(index == -1)
		        {
				    for(new i = 0; i < MAX_MP3; i ++)
					{
					    if(playerMP3_Create[playerid][i] == 1)
					    {
						    mysql_format(MySQL, query, sizeof(query), "UPDATE `%s` SET", MySQL_MP3);
						    mysql_format(MySQL, query, sizeof(query), "%s `playerMP3_Create` = '%d',",query, playerMP3_Create[playerid][i]);
						    mysql_format(MySQL, query, sizeof(query), "%s `playerMP3_Name` = '%s',",query, playerMP3_Name[playerid][i]);
							mysql_format(MySQL, query, sizeof(query), "%s `playerMP3_Index` = '%d',",query, playerMP3_Index[playerid][i]);
							mysql_format(MySQL, query, sizeof(query), "%s `playerMP3_Url` = '%s',",query, playerMP3_Url[playerid][i]);
							mysql_format(MySQL, query, sizeof(query), "%s `playerMP3_Title` = '%s'",query, playerMP3_Title[playerid][i]);
						    mysql_format(MySQL, query, sizeof(query), "%s WHERE `playerMP3_Name` = '%s' AND `playerMP3_Index` = '%d' LIMIT 1", query, playerMP3_Name[playerid][i], playerMP3_Index[playerid][i]);
						    mysql_tquery(MySQL, query, "", "");
						}
					}
				}
				else
				{
				    new i = index;
				    
				    if(playerMP3_Create[playerid][i] == 1)
				    {
					    mysql_format(MySQL, query, sizeof(query), "UPDATE `%s` SET", MySQL_MP3);
					    mysql_format(MySQL, query, sizeof(query), "%s `playerMP3_Create` = '%d',",query, playerMP3_Create[playerid][i]);
					    mysql_format(MySQL, query, sizeof(query), "%s `playerMP3_Name` = '%s',",query, playerMP3_Name[playerid][i]);
						mysql_format(MySQL, query, sizeof(query), "%s `playerMP3_Index` = '%d',",query, playerMP3_Index[playerid][i]);
						mysql_format(MySQL, query, sizeof(query), "%s `playerMP3_Url` = '%s',",query, playerMP3_Url[playerid][i]);
						mysql_format(MySQL, query, sizeof(query), "%s `playerMP3_Title` = '%s'",query, playerMP3_Title[playerid][i]);
					    mysql_format(MySQL, query, sizeof(query), "%s WHERE `playerMP3_Name` = '%s' AND `playerMP3_Index` = '%d' LIMIT 1", query, playerMP3_Name[playerid][i], playerMP3_Index[playerid][i]);
					    mysql_tquery(MySQL, query, "", "");
					}
				}
			}
			return 1;
        }
    }
	return 0;
}

public Audio_OnClientConnect(playerid)
{
	printf("%d접속오디오",playerid);
	return 1;
}

forward ORMDB(playerid);
public ORMDB(playerid) // psave
{
    if(!IsPlayerNPC(playerid))
	{
	    GetPlayerName(playerid, PlayerInfo[playerid][pName], MAX_PLAYER_NAME);
		new ORM:ormid = PlayerInfo[playerid][ORM_ID] = orm_create(MySQL_USER,MySQL);

		orm_addvar_int(ormid, PlayerInfo[playerid][pID], "id");
	    orm_addvar_string(ormid, PlayerInfo[playerid][pName], MAX_PLAYER_NAME, "pName");
		orm_addvar_string(ormid, PlayerInfo[playerid][pPassword], 128, "pPassword");
		orm_addvar_int(ormid, PlayerInfo[playerid][pSex], "pSex");
		orm_addvar_int(ormid, PlayerInfo[playerid][pAge], "pAge");
		orm_addvar_int(ormid, PlayerInfo[playerid][pSkin], "pSkin");
		orm_addvar_int(ormid, PlayerInfo[playerid][pBornYear], "pBornYear");
		orm_addvar_int(ormid, PlayerInfo[playerid][pBornMonth], "pBornMonth");
		orm_addvar_int(ormid, PlayerInfo[playerid][pBornDay], "pBornDay");
		orm_addvar_int(ormid, PlayerInfo[playerid][pCountry], "pCountry");
		orm_addvar_float(ormid, PlayerInfo[playerid][pPos][0], "pPosX");
		orm_addvar_float(ormid, PlayerInfo[playerid][pPos][1], "pPosY");
		orm_addvar_float(ormid, PlayerInfo[playerid][pPos][2], "pPosZ");
		orm_addvar_int(ormid, PlayerInfo[playerid][pAdmin], "pAdmin");
		orm_addvar_string(ormid, PlayerInfo[playerid][pAdminName], 128, "pAdminName");
		orm_addvar_int(ormid, PlayerInfo[playerid][pInterior], "pInterior");
		orm_addvar_int(ormid, PlayerInfo[playerid][pVirtualWorld], "pVirtualWorld");
		orm_addvar_float(ormid, PlayerInfo[playerid][pAngle], "pAngle");
		orm_addvar_int(ormid, PlayerInfo[playerid][pTutorial], "pTutorial");
		orm_addvar_int(ormid, PlayerInfo[playerid][pChatBan], "pChatBan");
		orm_addvar_int(ormid, PlayerInfo[playerid][pMoney], "pMoney");
		orm_addvar_float(ormid, PlayerInfo[playerid][pHealth], "pHealth");
		orm_addvar_float(ormid, PlayerInfo[playerid][pArmour], "pArmour");
		orm_addvar_float(ormid, PlayerInfo[playerid][pHungry], "pHungry");
		orm_addvar_float(ormid, PlayerInfo[playerid][pEnergy], "pEnergy");
		orm_addvar_int(ormid, PlayerInfo[playerid][pPhoneNumber], "pPhoneNumber");
		orm_addvar_int(ormid, PlayerInfo[playerid][pPhonePower], "pPhonePower");
		orm_addvar_int(ormid, PlayerInfo[playerid][pAccountNum], "pAccountNum");
		orm_addvar_int(ormid, PlayerInfo[playerid][pAccountMoney], "pAccountMoney");
		orm_addvar_int(ormid, PlayerInfo[playerid][pShopMode], "pShopMode");

		new string[50];
		for(new slot = 0; slot < MAX_ITEM_SLOT; slot ++)
		{
		    for(new item = 0; item < MAX_INVEN_ITEM; item ++)
		    {
		        format(string, sizeof(string), "InvenItem%d_%d",slot, item); orm_addvar_int(ormid, InvenItem[playerid][slot][item], string);
		        format(string, sizeof(string), "InvenItemNum%d_%d",slot, item); orm_addvar_int(ormid, InvenItemNum[playerid][slot][item], string);
			}
		}
		orm_setkey(ormid, "pName");
		orm_select(ormid, "OnPlayerDataLoad", "i", playerid);
	}
	return 1;
}

forward OnPlayerDataLoad(playerid);
public OnPlayerDataLoad(playerid)
{
	switch(orm_errno(PlayerInfo[playerid][ORM_ID]))
	{
	    case ERROR_NO_DATA:
		{
		    RegDialogue(playerid, 1);
		}
		case ERROR_OK:
		{
		    LogDialogue(playerid);
		    
		    if(IsItemHaveState(playerid, 1) == 1) { smsDatabaseLoad(playerid); privateNoteDatabaseLoad(playerid); numNoteDatabaseLoad(playerid); mp3DatabaseLoad(playerid); }
		}
	}
	orm_setkey(PlayerInfo[playerid][ORM_ID], "id");
	return 1;
}

forward KickEx(playerid, type);
public KickEx(playerid, type)
{
	if(type == 1)
	{
		//OnPlayerSave(playerid, -1);
		SetTimerEx("KickEx", 100, false, "dd", playerid, 2);
	}
	else if(type == 2) Kick(playerid);
	return 1;
}

forward ConnectScreen(playerid, type);
public ConnectScreen(playerid, type)
{
	if(type < 4)
	{
	    ClearChat(playerid, 20);
	    TogglePlayerControllable(playerid, false);
	    SetTimerEx("ConnectScreen", 50, false, "dd", playerid, type+1);
	}
	else if(type == 4) SetTimerEx("ConnectScreen", 2000, false, "dd", playerid, type+1);
	else if(type == 5)
	{
	    TogglePlayerControllable(playerid, false);
		SetTimerEx("FadeIn", FADE_DELAY, false, "id",playerid,255);
		SetTimerEx("ConnectScreen", 3000, false, "dd", playerid, type+1);
	}
	else if(type == 6) ORMDB(playerid);
	return 1;
}

forward OnPlayerLogin(playerid);
public OnPlayerLogin(playerid)
{
	ClearChat(playerid, 20);
	PlayerInfo[playerid][pLoginCheck] = true;
	Audio_StopEx(playerid, PlayerInfo[playerid][pStartBgm]);
	PlayerInfo[playerid][pStartBgm] = -1;
	TextDrawHideForPlayer(playerid, PlayerConnTD[playerid]);
	if(PlayerInfo[playerid][pTutorial] != 3) OnPlayerSpawn(playerid);
	else
	{
	    TextDrawBoxColor(BlackScreenTD[playerid], RGBToHex(0,0,0,255));
        TextDrawShowForPlayer(playerid, BlackScreenTD[playerid]);
		SetTimerEx("OnPlayerSpawn", 3000, false, "d", playerid);
	}
	return 1;
}

forward FadeIn(playerid, a);
public FadeIn(playerid, a)
{
	if(a < 0) a = 0;
	TextDrawBoxColor(BlackScreenTD[playerid], RGBToHex(0,0,0,a));
	TextDrawShowForPlayer(playerid, BlackScreenTD[playerid]);
	if (a) SetTimerEx("FadeIn", FADE_DELAY, false, "id", playerid, a-5); else TextDrawHideForPlayer(playerid, BlackScreenTD[playerid]);
	return 1;
}

forward FadeOut(playerid, a);
public FadeOut(playerid, a)
{
	if(a > 255) a = 255;
	TextDrawBoxColor(BlackScreenTD[playerid], RGBToHex(0,0,0,a));
	TextDrawShowForPlayer(playerid, BlackScreenTD[playerid]);
	if (a < 255) SetTimerEx("FadeOut", FADE_DELAY, false, "dd", playerid, a+5);
	return 1;
}

forward Tutorial(playerid, type);
public Tutorial(playerid, type)
{
	if(type == 1)
	{
	    ClearChat(playerid, 20);
	    SetPlayerPosEx(playerid, 1956.6008,1176.2942,1146.3369-1.0,22.9102+1.0, 1, playerid+1);

	    SetTimerEx("Tutorial", 2000, false, "dd", playerid, 2);

	    PlayerInfo[playerid][pRegInfoClick] = true;

	    InterpolateCameraPos(playerid, 1956.6008,1176.2942,1146.3369+0.5, 1956.6008,1176.2942,1146.3369+0.5, 10000);
	    InterpolateCameraLookAt(playerid, 1957.1389,1168.3273,1146.3369, 1957.1389,1168.3273,1146.3369, 10000);
	}
	else if(type == 2)
	{
	    /************************* 기본세팅 ※수정X *************************/
	    SetTimerEx("FadeIn", FADE_DELAY, false, "id",playerid,255);
	    
		new string[52];
		format(string, sizeof(string), "man");
		TextDrawSetString(RegInfoTD[playerid][6], string);
		PlayerInfo[playerid][pSex] = 1;

        format(string, sizeof(string), "%s", PlayerNameEx(playerid));
		TextDrawSetString(RegInfoTD[playerid][5], string);

		DestroyActor(PlayerInfo[playerid][pPlayerActor]);
		PlayerInfo[playerid][pPlayerActor] = CreateActor(DefaultSkin[PlayerInfo[playerid][pSex]-1][0], 1958.2168, 1172.1118, 1146.4017, 22.9102);
		SetActorVirtualWorld(PlayerInfo[playerid][pPlayerActor], playerid+1);
		PlayerInfo[playerid][pPlayerActorSkin] = DefaultSkin[PlayerInfo[playerid][pSex]-1][0];
		PlayerInfo[playerid][pPlayerActorIndex] = 0;
		format(string, sizeof(string), "%d", DefaultSkin[PlayerInfo[playerid][pSex]-1][0]);
		TextDrawSetString(RegInfoTD[playerid][24], string);

		format(string, sizeof(string), "None");
		TextDrawSetString(RegInfoTD[playerid][12], string);
		PlayerInfo[playerid][pCountry] = 0;

		PlayerInfo[playerid][pBornYear] = START_YEAR;
		format(string, sizeof(string), "%d", PlayerInfo[playerid][pBornYear]);
		TextDrawSetString(RegInfoTD[playerid][7], string);

		PlayerInfo[playerid][pBornMonth] = 1;
		format(string, sizeof(string), "%02.d", PlayerInfo[playerid][pBornMonth]);
		TextDrawSetString(RegInfoTD[playerid][8], string);

		PlayerInfo[playerid][pBornDay] = 1;
		format(string, sizeof(string), "%02.d", PlayerInfo[playerid][pBornDay]);
		TextDrawSetString(RegInfoTD[playerid][10], string);
		/************************* 기본세팅 ※수정X *************************/
	
        for(new i = 0; i < MAX_REGTD; i ++)
        {
	        TextDrawShowForPlayer(playerid, RegInfoTD[playerid][i]);
		}
		SelectTextDraw(playerid, 0x00000055);
	}
	return 1;
}

forward AutoSave();
public AutoSave()
{
	for(new i = 0; i < MAX_PLAYERS; i ++)
	{
	    if(IsPlayerLogin(i))
	    	OnPlayerSave(i, 1);
	}
	return 1;
}

forward ScreenStart(playerid, type);
public ScreenStart(playerid, type)
{
	if(type == 1)
	{
	    ClearChat(playerid, 10);
	
	    SetTimerEx("FadeIn", FADE_DELAY, false, "id",playerid,255);
	
	    PlayerInfo[playerid][pTutScreen] 	= type;
	    PlayerInfo[playerid][pIntroBgm] 	= Audio_Play(playerid, 2, false, true, false);
	    PlayerInfo[playerid][pSerLogoTimer] = SetTimerEx("ServerLoginScreen", 100, true, "d", playerid);
	    
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
	    
	    InterpolateCameraPos(playerid, 343.909576, -1720.065307, 26.618011, 377.188446, -1720.468505, 39.926601, 8000);
		InterpolateCameraLookAt(playerid, 348.899658, -1719.844116, 26.393878, 382.170379, -1720.284057, 40.308921, 8000);
		
		SetTimerEx("ScreenStart", 8000, false, "dd", playerid, type+1);
	}
	if(type == 2)
	{
	    PlayerInfo[playerid][pTutScreen] = type;
	    
	    ClearChat(playerid, 10);
	
	    SendClientMessage(playerid, COLOR_ORANGE,	"The Unlimited Role Play에 오신 것을 환영합니다!");
		SendClientMessage(playerid, COLOR_WHITE , 	"이 가이드는 처음 도시에 방문한 당신에게 도움이 될 것입니다.");
		SendClientMessage(playerid, COLOR_WHITE ,	"‘스페이스바’, ‘왼쪽 쉬프트키’ 를 눌러 장을 넘기거나 되돌릴 수 있습니다.");
		SendClientMessage(playerid, COLOR_WHITE ,	"앞으로의 생활에 큰 도움이 되는 내용이니 잠시 시간을 내어 모두 읽어볼 것을 권장합니다.");
		
		InterpolateCameraPos(playerid, 360.056182, -2057.901367, 30.456058, 359.245330, -2001.660278, 28.508575, 15000);
		InterpolateCameraLookAt(playerid, 363.106384, -2053.954833, 30.109222, 362.581573, -1997.938354, 28.379959, 15000);
	}
	if(type == 3)
	{
	    PlayerInfo[playerid][pTutScreen] = type;
	    
	    ClearChat(playerid, 10);
	
	    SendClientMessage(playerid, COLOR_WHITE , 	"Los Santos 도시로의 첫 방문 [1/10]");
		SendClientMessage(playerid, COLOR_WHITE , 	"자유와 기회의 도시 로스 산토스에 오신 것을 환영합니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"부푼 꿈을 안고 낯선 도시에 첫 발을 내딛는 순간부터 당신의 모험은 시작될 것입니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"새롭게 출발하는 당신의 캐릭터가 가진 것은 많지 않겠지만,");
		SendClientMessage(playerid, COLOR_WHITE , 	"도시에서 당신은 무엇이든 도전해보고 시도해 볼 수 있습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"당신만의 개성 있는 캐릭터가 어떤 삶을 살아가길 원하는지,");
		SendClientMessage(playerid, COLOR_WHITE , 	"당신이 어떤 플레이를 선호하는지에 따라 수많은 선택을 할 수 있습니다.");

	    InterpolateCameraPos(playerid, 1192.213745, -1511.874145, 81.319351, 1157.250244, -1413.450439, 81.319351, 15000);
		InterpolateCameraLookAt(playerid, 1196.790405, -1509.869506, 81.130088, 1161.985717, -1411.865356, 81.069458, 15000);
	}
	if(type == 4)
	{
	    PlayerInfo[playerid][pTutScreen] = type;
	    
	    ClearChat(playerid, 10);
	
	    SendClientMessage(playerid, COLOR_WHITE , 	"새로운 인생을 살아가기 [2/10]");
		SendClientMessage(playerid, COLOR_WHITE , 	"곧 당신이 타고 있는 배가 도시에 도착하면, 새 인생을 시작하기 전에");
		SendClientMessage(playerid, COLOR_WHITE , 	"당신이 살아갈 주거지를 먼저 찾아야 할 것입니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"새로운 거처를 찾기 전까지는 잠시 동안 무료 숙소에서 임시로 거주할 수 있습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"자신만의 보금자리를 개척해 나갈 준비가 됐다면,");
		SendClientMessage(playerid, COLOR_WHITE , 	"도시 곳곳에 있는 판매중인 집을 구매하거나 렌트해 그곳에서 살아갈 수 있습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"도시에는 구매 가능한 수많은 주거지가 있으며, 다른 유저와의 거래를 통해 집을 구매하거나");
		SendClientMessage(playerid, COLOR_WHITE , 	"호텔이나 빌라에서 돈을 주고 방을 렌트할 수도 있습니다.");
	
	    InterpolateCameraPos(playerid, 2125.165771, -1319.384887, 43.058486, 2268.543212, -1316.040649, 45.257484, 15000);
		InterpolateCameraLookAt(playerid, 2122.634765, -1315.288940, 41.710205, 2265.578857, -1312.185058, 44.097183, 15000);
	}
	if(type == 5)
	{
	    PlayerInfo[playerid][pTutScreen] = type;
	    
	    ClearChat(playerid, 10);
	
	    SendClientMessage(playerid, COLOR_WHITE , 	"이동 수단 [3/10]");
		SendClientMessage(playerid, COLOR_WHITE , 	"당신은 도시에서 원하는 곳으로 가기 위해 다양한 교통수단을 이용할 수 있습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"아직 충분한 돈이 모이지 않았다면 버스 정류장에서 버스를 기다리거나,");
		SendClientMessage(playerid, COLOR_WHITE , 	"지하철역을 이용하거나, 전화로 택시를 부르거나, 약간의 돈을 주고 차를 렌트할 수도 있습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"544 번호로 전화를 걸어 콜택시 서비스를 이용하거나, 도시 곳곳에 있는 렌터카를 대여해 사용하세요.");
		SendClientMessage(playerid, COLOR_WHITE , 	"충분한 돈이 모였다면, 차량 판매점에 방문해 자신만의 자가용을 직접 구매할 수 있습니다.");
	
	    InterpolateCameraPos(playerid, 1765.369384, -1999.005859, 33.334999, 1849.172851, -1913.728759, 32.117454, 15000);
		InterpolateCameraLookAt(playerid, 1762.897949, -1994.957397, 31.753190, 1844.541625, -1912.475952, 30.709375, 15000);
	}
	if(type == 6)
	{
	    PlayerInfo[playerid][pTutScreen] = type;
	    
	    ClearChat(playerid, 10);
	
	    SendClientMessage(playerid, COLOR_WHITE , 	"건강한 생활 방식을 유지하세요. [4/10]");
		SendClientMessage(playerid, COLOR_WHITE , 	"당신의 캐릭터가 언제나 건강을 유지하도록 하세요.");
		SendClientMessage(playerid, COLOR_WHITE , 	"캐릭터의 안전을 위해 건강과 체력 두 가지의 상태를 항상 확인해야 합니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"차에 치이거나, 높은 곳에서 떨어지거나, 병에 걸리거나, 다른 유저에게 피해를 입으면 캐릭터의 건강 수치가 하락합니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"건강 수치가 모두 감소하면 캐릭터는 사망하여 병원에서 리스폰 되며 죽음 패널티를 받게 될 것입니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"체력 수치는 캐릭터가 굶거나, 일을 하거나, 다른 유저에게 피해를 입었을 때 하락합니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"체력 수치가 모두 감소하면 캐릭터가 기절하여 잠시 동안 의식을 잃게 될 것입니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"도시 곳곳에 있는 음식점에서 음식을 꾸준히 섭취하고, 병원에서 당신의 건강을 점검하세요.");
	
	    InterpolateCameraPos(playerid, 2079.083496, -1806.532714, 27.471630, 2106.389404, -1815.412841, 14.367520, 15000);
		InterpolateCameraLookAt(playerid, 2082.755615, -1803.288696, 26.475778, 2109.456054, -1811.463989, 14.323866, 15000);
	}
	if(type == 7)
	{
	    PlayerInfo[playerid][pTutScreen] = type;
	    
	    ClearChat(playerid, 10);
	
	    SendClientMessage(playerid, COLOR_WHITE , 	"다른 사람들과 만나고 소통하세요. [5/10]");
		SendClientMessage(playerid, COLOR_WHITE , 	"로스 산토스에서는 다양한 곳에서 온 수많은 사람들이 개성 있는 사회를 이루어 살아가고 있습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"당신은 앞으로 당신과 다른 흥미, 다른 가치관을 가진 플레이어들을 계속 마주치게 될 것입니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"그리고 다른 캐릭터와 친구가 되거나, 같은 소속원이 되거나, 심지어 가족이 될 수도 있습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"각자의 개성을 가진 다른 캐릭터들과 원하는 사업을 함께 도모하거나, 도시를 주무를만한 조직을 만들기 위해 손을 잡아보세요.");
		SendClientMessage(playerid, COLOR_WHITE , 	"많은 사람들을 만나고 소통할수록 당신에게 더 많은 기회가 생길 것이며, 더 많은 도움을 받을 수도 있습니다.");
	
	    InterpolateCameraPos(playerid, 2346.292480, -1665.914306, 20.882263, 2322.870849, -1644.095947, 15.284640, 15000);
		InterpolateCameraLookAt(playerid, 2342.073730, -1663.278320, 20.378221, 2319.044433, -1640.877563, 15.289537, 15000);
	}
	if(type == 8)
	{
	    PlayerInfo[playerid][pTutScreen] = type;
	    
	    ClearChat(playerid, 10);
	
	    SendClientMessage(playerid, COLOR_WHITE , 	"새로운 소유물을 축적하세요. [6/10]");
		SendClientMessage(playerid, COLOR_WHITE , 	"당신은 도시에서 다른 사람과의 거래나 경매, 혹은 커뮤니티를 이용해 재산을 늘리고 소유물을 축적할 수 있습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"자신의 주택을 구매하는 것뿐만 아니라, 경매에 나온 다른 건물을 사들여 그곳에서 자신만의 사업을 시작할 수도 있습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"옷 가게와 쇼핑몰에서 자신만의 캐릭터를 개성 있게 만들어줄 아이템을 구매할 수도 있고,");
		SendClientMessage(playerid, COLOR_WHITE , 	"캐릭터를 더욱 돋보이게 해줄 탈것을 구매하는 것도 좋습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"정당하게 직업과 사업, 거래를 통해 부를 축적할 수 있지만, 자신만의 방법으로");
		SendClientMessage(playerid, COLOR_WHITE , 	"규칙을 어기지 않는 선에서 타인의 소유물을 빼앗을 수도 있습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"하지만 당신의 캐릭터가 반드시 부자이고 권력자일 필요는 없습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"오히려 끝없는 부의 추구는 당신의 캐릭터가 정체성을 잃게 하거나 개성 있는 캐릭터를 만들기 힘들게 하는 방해물이 될 수도 있습니다.");
	
	    InterpolateCameraPos(playerid, 1049.916748, -1387.236450, 23.631523, 1103.313964, -1368.878662, 36.514125, 15000);
		InterpolateCameraLookAt(playerid, 1053.723999, -1390.456176, 23.260484, 1105.670898, -1373.211914, 35.697319, 15000);
	}
	if(type == 9)
	{
	    PlayerInfo[playerid][pTutScreen] = type;
	    
	    ClearChat(playerid, 10);
	
	    SendClientMessage(playerid, COLOR_WHITE , 	"새로운 직업을 가지기 [7/10]");
		SendClientMessage(playerid, COLOR_WHITE , 	"당신은 물건을 구매하기 전에, 먼저 돈을 벌어야 할 것입니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"도시에는 돈을 벌고 캐릭터의 배경을 만들어줄 수많은 직업과 일거리가 존재합니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"신문에서 당신의 캐릭터가 할 수 있는 직업을 탐색하거나,");
		SendClientMessage(playerid, COLOR_WHITE , 	"다른 캐릭터가 사업에 필요한 일자리를 광고하고 있다면 연락해 보세요.");
		SendClientMessage(playerid, COLOR_WHITE , 	"혹은 경찰이나 소방관, 교도관, 보안관, 의사와 같이 더 전문적이고 안정적인 직업에 도전해 볼 수도 있습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"물론 당신은 자신만의 방법으로, 혹은 불법적인 방법으로 돈을 벌 수 있습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"모든 것은 당신의 창의력에 달려 있습니다.");
	
	    InterpolateCameraPos(playerid, 1959.135009, -1741.060913, 21.221527, 1961.052001, -1793.281005, 16.762872, 15000);
		InterpolateCameraLookAt(playerid, 1955.539672, -1744.446777, 20.440664, 1957.430419, -1789.842773, 16.512977, 15000);
	}
	if(type == 10)
	{
	    PlayerInfo[playerid][pTutScreen] = type;
	    
	    ClearChat(playerid, 10);
	
	    SendClientMessage(playerid, COLOR_WHITE , 	"공공 서비스 [8/10]");
		SendClientMessage(playerid, COLOR_WHITE , 	"로스 산토스시의 공공 서비스는 당신이 도움을 필요로 할 때 언제나 부를 수 있습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"법 집행기관으로는 로스 산토스 경찰서(LSPD)와 산 안드레스 보안관지서(SASD)가 있습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"산 안드레스 교정국(DOC)은 산 안드레스 주의 교도소를 관리하고 교정 관련 업무를 맡고 있습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"로스 산토스 소방서(LSFD)와 올 세인츠 종합병원(ASGH)은 화재, 구조, 구급, 의료 서비스를 담당하고 있습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"당신이 도움을 필요로 한다면, ‘911’ 번호로 전화를 걸어 공공 서비스를 이용할 수 있습니다.");
	
	    InterpolateCameraPos(playerid, 1512.456420, -1727.339477, 30.910709, 1521.739624, -1589.874267, 22.946533, 15000);
		InterpolateCameraLookAt(playerid, 1516.052490, -1723.987548, 29.998260, 1525.158691, -1593.470703, 22.333934, 15000);
	}
	if(type == 11)
	{
	    PlayerInfo[playerid][pTutScreen] = type;
	    
	    ClearChat(playerid, 10);
	
	    SendClientMessage(playerid, COLOR_WHITE , 	"게임 규칙 [9/10]");
		SendClientMessage(playerid, COLOR_WHITE , 	"게임에 정해진 규칙이 있다는 것을 항상 명심하세요. 다른 모든 유저와 관리자의 지도를 늘 존중해야 합니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"이곳이 롤플레잉 서버인 만큼 당신은 항상 롤플레잉 규칙을 준수해야 하고,");
		SendClientMessage(playerid, COLOR_WHITE , 	"항상 주변의 다른 유저들도 진지하게 게임에 몰입할 수 있도록 스스로의 언행에 주의해야 합니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"TURP는 다른 유저들이 자신의 롤플레잉에 몰입하는 것을 방해하는 유저에게 매우 냉정하고 엄격한 제재를 가할 것입니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"아직 롤플레잉에 대한 지식이 충분하지 않다면, 도움을 요청하고 질문하는 것을 망설이지 마세요.");
	
		InterpolateCameraPos(playerid, 1398.074340, -1725.924072, 29.844783, 1555.293334, -1720.757324, 23.126539, 15000);
		InterpolateCameraLookAt(playerid, 1401.437500, -1729.527221, 29.004034, 1552.337646, -1724.767089, 22.695007, 15000);
	}
	if(type == 12)
	{
	    PlayerInfo[playerid][pTutScreen] = type;
	    
	    ClearChat(playerid, 10);
	    
	    SendClientMessage(playerid, COLOR_WHITE , 	"새로운 모험이 곧 시작됩니다. [10/10]");
		SendClientMessage(playerid, COLOR_WHITE , 	"서버의 공식 커뮤니티 http://cafe.daum.net/turp 에서 다른 플레이어들과");
		SendClientMessage(playerid, COLOR_WHITE , 	"유용한 정보를 공유하고 다양한 게시판을 이용할 수 있습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"커뮤니티에서는 게임 내의 소유물을 거래하거나, 광고를 이용하는 등 게임 내의 롤플레잉을 이어갈 수도 있습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"궁금한 것이나 도움을 요청할 일이 있다면, /질문 명령어와 /도움요청 명령어를 이용하세요.");
		SendClientMessage(playerid, COLOR_WHITE , 	"관리자의 도움이 필요하거나, 타 플레이어에게 부당한 일을 당했다면 /신고 명령어를 이용해 도움을 받을 수 있습니다.");
		SendClientMessage(playerid, COLOR_WHITE , 	"당신이 롤플레잉에 진지하게 임할수록 게임이 더 재밌어지고, 주변 유저들이 당신에게 더 많은 흥밋거리와 기회를 줄 것이라는 점을 늘 기억하세요.");

		SendClientMessage(playerid, COLOR_ORANGE,	"The Unlimited Role Play에 오신 것을 환영합니다!");
	
	    InterpolateCameraPos(playerid, 738.265930, -1728.151611, 6.858604, 715.557373, -1649.277221, 6.452390, 15000);
		InterpolateCameraLookAt(playerid, 736.950683, -1723.343872, 6.463360, 715.557373, -1644.537841, 4.859072, 15000);
		
		PlayerInfo[playerid][pTutorial] = 2;
		
		SetTimerEx("DestorySpectating", 15000, false, "d", playerid);
	}
}

forward DestorySpectating(playerid);
public DestorySpectating(playerid)
{
    TogglePlayerSpectating(playerid, false);
    OnPlayerSpawn(playerid);
}

forward ServerLoginScreen(playerid);
public ServerLoginScreen(playerid)
{
	if(0 <= PlayerInfo[playerid][pSerLogoLevel] <= 14)
	{
		PlayerTextDrawHide(playerid, logoTD[playerid][0]);
	}
	else if(16 <= PlayerInfo[playerid][pSerLogoLevel] <= 30)
	{
	    PlayerTextDrawHide(playerid, logoTD[playerid][1]);
	}
	PlayerInfo[playerid][pSerLogoLevel] ++;
	switch(PlayerInfo[playerid][pSerLogoLevel])
	{
	    case 0: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFF00); }
		case 1: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFF11); }
		case 2: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFF22); }
		case 3: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFF33); }
		case 4: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFF44); }
		case 5: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFF55); }
		case 6: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFF66); }
		case 7: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFF77); }
		case 8: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFF88); }
		case 9: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFF99); }
		case 10: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFFAA); }
		case 11: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFFBB); }
		case 12: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFFCC); }
		case 13: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFFDD); }
		case 14: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFFEE); }
		case 15: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFFFF); }

		case 16: {PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFF00);}
		case 17: {PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFF11);}
		case 18: {PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFF22);}
		case 19: {PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFF33);}
		case 20: {PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFF44);}
		case 21: {PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFF55);}
		case 22: {PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFF66);}
		case 23: {PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFF77);}
		case 24: {PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFF88);}
		case 25: {PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFF99);}
		case 26: {PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFFAA);}
		case 27: {PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFFBB);}
		case 28: {PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFFCC);}
		case 29: {PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFFDD);}
		case 30: {PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFFEE);}
		case 31: {PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFFFF);}
	}
	if(0 <= PlayerInfo[playerid][pSerLogoLevel] <= 15)
	{
		PlayerTextDrawShow(playerid, logoTD[playerid][0]);
	}
	else if(16 <= PlayerInfo[playerid][pSerLogoLevel] <= 31)
	{
		PlayerTextDrawShow(playerid, logoTD[playerid][1]);
	}
	else if(PlayerInfo[playerid][pSerLogoLevel] == 42)
	{
	    KillTimerEx(PlayerInfo[playerid][pSerLogoTimer]);
	    PlayerInfo[playerid][pSerLogoLevel] = 25;
	    PlayerInfo[playerid][pSerLogoTimer] = SetTimerEx("ServerLoginScreen2",100,true, "i",playerid);
	}
	return 1;
}

forward ServerLoginScreen2(playerid);
public ServerLoginScreen2(playerid)
{
    if(10 <= PlayerInfo[playerid][pSerLogoLevel] <= 25)
	{
	    PlayerTextDrawHide(playerid, logoTD[playerid][0]);
	    PlayerTextDrawHide(playerid, logoTD[playerid][1]);
	}
	PlayerInfo[playerid][pSerLogoLevel] --;
	switch(PlayerInfo[playerid][pSerLogoLevel])
	{
	    case 10: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFF00);PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFF00);}
		case 11: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFF11); PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFF11);}
		case 12: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFF22); PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFF22);}
		case 13: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFF33); PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFF33);}
		case 14: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFF44); PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFF44);}
		case 15: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFF55); PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFF55);}
		case 16: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFF66); PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFF66);}
		case 17: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFF77); PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFF77);}
		case 18: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFF88); PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFF88);}
		case 19: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFFAA); PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFF99);}
		case 20: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFFAA); PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFFAA);}
		case 21: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFFBB); PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFFBB);}
		case 22: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFFCC); PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFFCC);}
		case 23: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFFDD); PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFFDD);}
		case 24: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFFEE); PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFFEE);}
		case 25: {PlayerTextDrawColor(playerid,logoTD[playerid][0],0xFFFFFFFF); PlayerTextDrawColor(playerid,logoTD[playerid][1],0xFFFFFFFF);}
	}
	if(10 <= PlayerInfo[playerid][pSerLogoLevel] <= 25)
	{
		PlayerTextDrawShow(playerid, logoTD[playerid][0]);
		PlayerTextDrawShow(playerid, logoTD[playerid][1]);
	}
	else if(PlayerInfo[playerid][pSerLogoLevel] == 9)
	{
	    PlayerTextDrawHide(playerid, logoTD[playerid][1]);
	    PlayerTextDrawHide(playerid, logoTD[playerid][0]);
	}
	else if(PlayerInfo[playerid][pSerLogoLevel] < 1)
	{
	    KillTimerEx(PlayerInfo[playerid][pSerLogoTimer]);
	    PlayerInfo[playerid][pSerLogoLevel] = 0;
	    PlayerTextDrawHide(playerid, logoTD[playerid][1]);
	    PlayerTextDrawHide(playerid, logoTD[playerid][0]);
	}
	return 1;
}

/********************* DB Save *********************/
stock BuildDataGenerate(Float:inX, Float:inY, Float:inZ, Float:outX, Float:outY, Float:outZ, name[], ininterior, outinterior, invirtualworld, outvirtualworld = -1, type)
{
    for(new b = 0; b < MAX_BUILD; b ++)
	{
	    if(!BuildInfo[b][bCreate])
	    {
	        new query[100];
	        mysql_format(MySQL, query, sizeof(query),"INSERT INTO `%s` (`bNumber`) VALUES ('%d')", MySQL_BUILD, b);
	        mysql_query(MySQL, query, false);
	        
	        BuildInfo[b][bCreate] 			= 1;
	        BuildInfo[b][bNumber] 			= b;
	        BuildInfo[b][bType]				= type;
	        BuildInfo[b][bInInterior] 		= ininterior;
	        BuildInfo[b][bOutInterior] 		= outinterior;
	        BuildInfo[b][bInVirtualWorld] 	= invirtualworld;
	        if(outvirtualworld == -1)
				BuildInfo[b][bOutVirtualWorld] = b+1;
	        else
				BuildInfo[b][bOutVirtualWorld] = outvirtualworld;
			BuildInfo[b][bInPos][0] 		= inX;
	        BuildInfo[b][bInPos][1] 		= inY;
	        BuildInfo[b][bInPos][2] 		= inZ;
	        BuildInfo[b][bOutPos][0] 		= outX;
	        BuildInfo[b][bIsSell]           = 0;
	        BuildInfo[b][bOutPos][1] 		= outY;
	        BuildInfo[b][bOutPos][2] 		= outZ;
	        strmid(BuildInfo[b][bOwner], 	"Los Santos", 0, 25, 25);
	        strmid(BuildInfo[b][bName], 	name, 0, 128, 128);
	        BuildInfo[b][bInTextLabelID] 	= Create3DTextLabel(buildLabelStyle(BuildInfo[b][bNumber]), COLOR_BUILD, BuildInfo[b][bInPos][0], BuildInfo[b][bInPos][1], BuildInfo[b][bInPos][2], 10.0, invirtualworld);
	        //BuildInfo[b][bInPickup] 		= CreatePickup(1239, 1, inX, inX, inX, invirtualworld);
	        if(BuildInfo[b][bType] == 1)
			{
				if(BuildInfo[b][bIsSell] == 0)
				{
					BuildInfo[b][bInPickup] = CreatePickup(1273, 1, BuildInfo[b][bInPos][0], BuildInfo[b][bInPos][1], BuildInfo[b][bInPos][2], BuildInfo[b][bInVirtualWorld]);
				}
				else BuildInfo[b][bInPickup] = CreatePickup(1272, 1, BuildInfo[b][bInPos][0], BuildInfo[b][bInPos][1], BuildInfo[b][bInPos][2], BuildInfo[b][bInVirtualWorld]);
				BuildInfo[b][bOutPickup] = CreatePickup(1318, 1, BuildInfo[b][bOutPos][0], BuildInfo[b][bOutPos][1], BuildInfo[b][bOutPos][2], BuildInfo[b][bOutVirtualWorld]);
			}
			else if(BuildInfo[b][bType] == 2)
			{
				BuildInfo[b][bInPickup] = CreatePickup(1274, 1, BuildInfo[b][bInPos][0], BuildInfo[b][bInPos][1], BuildInfo[b][bInPos][2], BuildInfo[b][bInVirtualWorld]);
				BuildInfo[b][bOutPickup] = CreatePickup(1318, 1, BuildInfo[b][bOutPos][0], BuildInfo[b][bOutPos][1], BuildInfo[b][bOutPos][2], BuildInfo[b][bOutVirtualWorld]);
			}
			else if(BuildInfo[b][bType] == 0)
			{
				BuildInfo[b][bInPickup] = CreatePickup(1239, 1, BuildInfo[b][bInPos][0], BuildInfo[b][bInPos][1], BuildInfo[b][bInPos][2], BuildInfo[b][bInVirtualWorld]);
				BuildInfo[b][bOutPickup] = CreatePickup(1239, 1, BuildInfo[b][bOutPos][0], BuildInfo[b][bOutPos][1], BuildInfo[b][bOutPos][2], BuildInfo[b][bOutVirtualWorld]);
			}
			//BuildInfo[b][bOutPickup] 		= CreatePickup(1239, 1, outX, outX, outX, outvirtualworld);
			
	        BuildDataSave(b);
	        return 1;
	    }
	}
	return 0;
}

forward BuildDataSave(buildid);
public BuildDataSave(buildid)
{
	if(BuildInfo[buildid][bCreate] == 1)
	{
	    new query[1024];
		mysql_format(MySQL, query, sizeof(query), "UPDATE `%s` SET", MySQL_BUILD);
		mysql_format(MySQL, query, sizeof(query), "%s `bCreate` = '%d',", query, BuildInfo[buildid][bCreate]);
		mysql_format(MySQL, query, sizeof(query), "%s `bNumber` = '%d',", query, BuildInfo[buildid][bNumber]);
		mysql_format(MySQL, query, sizeof(query), "%s `bName` = '%s',", query, BuildInfo[buildid][bName]);
		mysql_format(MySQL, query, sizeof(query), "%s `bInInterior` = '%d',", query, BuildInfo[buildid][bInInterior]);
		mysql_format(MySQL, query, sizeof(query), "%s `bType` = '%d',", query, BuildInfo[buildid][bType]);
		mysql_format(MySQL, query, sizeof(query), "%s `bOutInterior` = '%d',", query, BuildInfo[buildid][bOutInterior]);
		mysql_format(MySQL, query, sizeof(query), "%s `bInVirtualWorld` = '%d',", query, BuildInfo[buildid][bInVirtualWorld]);
		mysql_format(MySQL, query, sizeof(query), "%s `bOutVirtualWorld` = '%d',", query, BuildInfo[buildid][bOutVirtualWorld]);
		mysql_format(MySQL, query, sizeof(query), "%s `bOwner` = '%s',", query, BuildInfo[buildid][bOwner]);
		mysql_format(MySQL, query, sizeof(query), "%s `bIsSell` = '%d',", query, BuildInfo[buildid][bIsSell]);
		mysql_format(MySQL, query, sizeof(query), "%s `bInPos_0` = '%.4f',", query, BuildInfo[buildid][bInPos][0]);
		mysql_format(MySQL, query, sizeof(query), "%s `bInPos_1` = '%.4f',", query, BuildInfo[buildid][bInPos][1]);
		mysql_format(MySQL, query, sizeof(query), "%s `bInPos_2` = '%.4f',", query, BuildInfo[buildid][bInPos][2]);
		mysql_format(MySQL, query, sizeof(query), "%s `bOutPos_0` = '%.4f',", query, BuildInfo[buildid][bOutPos][0]);
		mysql_format(MySQL, query, sizeof(query), "%s `bOutPos_1` = '%.4f',", query, BuildInfo[buildid][bOutPos][1]);
		mysql_format(MySQL, query, sizeof(query), "%s `bOutPos_2` = '%.4f'", query, BuildInfo[buildid][bOutPos][2]);
		mysql_format(MySQL, query, sizeof(query), "%s WHERE `bNumber` = '%d'", query, BuildInfo[buildid][bNumber]);
		mysql_format(MySQL, query, sizeof(query), "%s", query);
	    mysql_query(MySQL, query, false);
		return 1;
	}
	return 0;
}

forward BuildDataLoad();
public BuildDataLoad()
{
	if(ServerDBConnect != 1) return print("Build table Loading Fail. [MySQL not connection]");

	new query[100];
	for(new b = 0; b < MAX_BUILD; b ++)
	{
		mysql_format(MySQL, query, sizeof(query),"SELECT * FROM `%s` WHERE `bNumber` = '%d' LIMIT 1", MySQL_BUILD, b);
		new Cache:result = mysql_query(MySQL, query, true);
		if(cache_num_rows() > 0)
		{
		    new temp[128];
		    cache_get_value_name_int(0, "bCreate", BuildInfo[b][bCreate]);
		    cache_get_value_name_int(0, "bNumber", BuildInfo[b][bNumber]);
		    cache_get_value_name(0, "bName", temp); strmid(BuildInfo[b][bName], temp, 0, 128, 128);
		    cache_get_value_name_int(0, "bType", BuildInfo[b][bType]);
		    cache_get_value_name_int(0, "bInInterior", BuildInfo[b][bInInterior]);
		    cache_get_value_name_int(0, "bOutInterior", BuildInfo[b][bOutInterior]);
		    cache_get_value_name_int(0, "bInVirtualWorld", BuildInfo[b][bInVirtualWorld]);
		    cache_get_value_name_int(0, "bOutVirtualWorld", BuildInfo[b][bOutVirtualWorld]);
		    cache_get_value_name_int(0, "bIsSell", BuildInfo[b][bIsSell]);
		    cache_get_value_name_float(0, "bInPos_0", BuildInfo[b][bInPos][0]);
		    cache_get_value_name_float(0, "bInPos_1", BuildInfo[b][bInPos][1]);
		    cache_get_value_name_float(0, "bInPos_2", BuildInfo[b][bInPos][2]);
		    cache_get_value_name_float(0, "bOutPos_0", BuildInfo[b][bOutPos][0]);
		    cache_get_value_name_float(0, "bOutPos_1", BuildInfo[b][bOutPos][1]);
		    cache_get_value_name_float(0, "bOutPos_2", BuildInfo[b][bOutPos][2]);
		    cache_get_value_name(0, "bOwner", temp); strmid(BuildInfo[b][bOwner], temp, 0, 128, 128);

		    BuildInfo[b][bInTextLabelID] 	= Create3DTextLabel(buildLabelStyle(BuildInfo[b][bNumber]), COLOR_BUILD, BuildInfo[b][bInPos][0], BuildInfo[b][bInPos][1], BuildInfo[b][bInPos][2], 10.0, BuildInfo[b][bInVirtualWorld]);
	        if(BuildInfo[b][bType] == 1)
			{
				if(BuildInfo[b][bIsSell] == 0)
				{
					BuildInfo[b][bInPickup] = CreatePickup(1273, 1, BuildInfo[b][bInPos][0], BuildInfo[b][bInPos][1], BuildInfo[b][bInPos][2], BuildInfo[b][bInVirtualWorld]);
				}
				else BuildInfo[b][bInPickup] = CreatePickup(1272, 1, BuildInfo[b][bInPos][0], BuildInfo[b][bInPos][1], BuildInfo[b][bInPos][2], BuildInfo[b][bInVirtualWorld]);
				BuildInfo[b][bOutPickup] = CreatePickup(1318, 1, BuildInfo[b][bOutPos][0], BuildInfo[b][bOutPos][1], BuildInfo[b][bOutPos][2], BuildInfo[b][bOutVirtualWorld]);
			}
			else if(BuildInfo[b][bType] == 2)
			{
				BuildInfo[b][bInPickup] = CreatePickup(1274, 1, BuildInfo[b][bInPos][0], BuildInfo[b][bInPos][1], BuildInfo[b][bInPos][2], BuildInfo[b][bInVirtualWorld]);
				BuildInfo[b][bOutPickup] = CreatePickup(1318, 1, BuildInfo[b][bOutPos][0], BuildInfo[b][bOutPos][1], BuildInfo[b][bOutPos][2], BuildInfo[b][bOutVirtualWorld]);
			}
			else if(BuildInfo[b][bType] == 0)
			{
				BuildInfo[b][bInPickup] = CreatePickup(1239, 1, BuildInfo[b][bInPos][0], BuildInfo[b][bInPos][1], BuildInfo[b][bInPos][2], BuildInfo[b][bInVirtualWorld]);
				BuildInfo[b][bOutPickup] = CreatePickup(1239, 1, BuildInfo[b][bOutPos][0], BuildInfo[b][bOutPos][1], BuildInfo[b][bOutPos][2], BuildInfo[b][bOutVirtualWorld]);
			}
		}
		cache_delete(result);
	}
	return 1;
}

forward SELECTTEXTDRAW(playerid);
public SELECTTEXTDRAW(playerid)
{
    SelectTextDraw(playerid, COLOR_TDCLICK);
}

forward PlayerHUD(playerid, bool:visible);
public PlayerHUD(playerid, bool:visible)
{
	if(visible == true)
	{
	    SetPlayerProgressBarValue(playerid, PlayerInfo[playerid][pHudBar][0], PlayerInfo[playerid][pHealth]);
	    SetPlayerProgressBarValue(playerid, PlayerInfo[playerid][pHudBar][1], PlayerInfo[playerid][pArmour]);
	    SetPlayerProgressBarValue(playerid, PlayerInfo[playerid][pHudBar][2], PlayerInfo[playerid][pHungry]);
	    SetPlayerProgressBarValue(playerid, PlayerInfo[playerid][pHudBar][3], PlayerInfo[playerid][pEnergy]);

		new str[20];
		format(str, sizeof(str), "%08.d", PlayerInfo[playerid][pMoney]);
		TextDrawSetString(PlayerHUDTD[playerid][0], str);

		for(new i = 0; i < MAX_HUD_BAR; i ++)
		{
		    ShowPlayerProgressBar(playerid, PlayerInfo[playerid][pHudBar][i]);
		}

	    for(new i = 0; i < MAX_HUD_TD; i ++)
		{
	    	TextDrawShowForPlayer(playerid, PlayerHUDTD[playerid][i]);
	    }
	}
	else if(visible == false)
	{
	    for(new i = 0; i < MAX_HUD_BAR; i ++)
		{
		    HidePlayerProgressBar(playerid, PlayerInfo[playerid][pHudBar][i]);
		}

	    for(new i = 0; i < MAX_HUD_TD; i ++)
		{
	    	TextDrawHideForPlayer(playerid, PlayerHUDTD[playerid][i]);
	    }
	}
}

forward CallConTimer(playerid);
public CallConTimer(playerid)
{
    if(IsPlayerLogin(playerid))
	{
	    new giveplayerid = PlayerInfo[playerid][pCallPlayer];
	    if(IsPlayerLogin(giveplayerid))
	    {
	        if(PlayerInfo[giveplayerid][pPhonePower] == 1)
	        {
	            if(PlayerInfo[giveplayerid][pCallNum] == -1 || PlayerInfo[giveplayerid][pCallNum] == PlayerInfo[playerid][pPhoneNumber])
	            {
		            if(PlayerInfo[giveplayerid][pCCallPlayer] != -1)
					{
		            	PlayerInfo[playerid][pCallConLevel] ++;
						if(PlayerInfo[playerid][pCallConLevel] >= MAX_CALLCON_SECOND)
						{
						    KillTimerEx(PlayerInfo[playerid][pCallConTimer]);
						    Audio_StopEx(playerid, PlayerInfo[playerid][pMCallBGM]);
						    Audio_StopEx(playerid, PlayerInfo[giveplayerid][pCCallBGM]);
						    SendErrorMessage(playerid, "상대방이 전화를 받지않습니다.");
						    PlayerInfo[playerid][pCallPlayer] = -1;
						}
						return 1;
					}
				}
				else SendErrorMessage(playerid, "상대방이 다른 사람과 전화중입니다.");
	        }
	        else SendErrorMessage(playerid, "상대방의 휴대전화 전원이 꺼져있습니다.");
	    }
	    else SendErrorMessage(playerid, "상대방이 게임을 나갔습니다.");
	}
	KillTimerEx(PlayerInfo[playerid][pCallConTimer]);
	Audio_StopEx(playerid, PlayerInfo[playerid][pMCallBGM]);
	PlayerInfo[playerid][pCallPlayer] = -1;
	PlayerInfo[playerid][pCallNum] = -1;
	PlayerInfo[playerid][pCallTake] = 0;
	PhoneMode(playerid, false);
	return 1;
}
/********************* DB Save *********************/
//========================= stock =========================//
stock IsPlayerLogin(playerid)
{
	return PlayerInfo[playerid][pLoginCheck];
}

stock ResetPlayerVar(playerid)
{
    new Rest[pInfo];
    Rest[pPassword] = -1;
    Rest[pPlayerActor] = -1;
    Rest[pFirstSpawn] = 1;
    Rest[pItemDisPlace][0] = -1;
    Rest[pItemDisPlace][1] = -1;
    Rest[pCallNum] = -1;
	Rest[pCallPlayer] = -1;
	Rest[pCallConTimer] = -1;
	Rest[pMCallBGM] = -1;
	Rest[pCCallBGM] = -1;
	Rest[pCCallPlayer] = -1;
	Rest[pStartBgm] = -1;
	Rest[pIntroBgm] = -1;
	Rest[pSerLogoTimer] = -1;
	Rest[pAudio_Mp3] = -1;
	Rest[pObjectEdit][0] = -1;
	Rest[pObjectEdit][1] = -1;
	PlayerInfo[playerid] = Rest;
	strmid(PlayerInfo[playerid][pAdminName], "None", 0, 128, 128);
	
	for(new i = 0; i < MAX_NOTE; i ++)
	{
		privateNote_Create[playerid][i] = 0;
		privateNote_Date[playerid][i][0] = 0;
		privateNote_Date[playerid][i][1] = 0;
		privateNote_Date[playerid][i][2] = 0;
		privateNote_Time[playerid][i][0] = 0;
		privateNote_Time[playerid][i][1] = 0;
		privateNote_Index[playerid][i] = -1;
		strmid(privateNote_Name[playerid][i], "", 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
		strmid(privateNote_Content[playerid][i], "", 0, 128, 128);
	}
	
	for(new i = 0; i < MAX_SMS; i ++)
	{
		SMSSend_CallNum[playerid][i] = -1;
		SMSSend_Index[playerid][i] = -1;
		SMSSend_Year[playerid][i] = 0;
		SMSSend_Month[playerid][i] = 0;
		SMSSend_Day[playerid][i] = 0;
		SMSSend_Hour[playerid][i] = 0;
		SMSSend_Minute[playerid][i] = 0;
		strmid(SMSSend_Content[playerid][i], "", 0, 128, 128);

		SMSReceive_CallNum[playerid][i] = -1;
		SMSReceive_Index[playerid][i] = -1;
		SMSReceive_HitChk[playerid][i] = 0;
		SMSReceive_Year[playerid][i] = 0;
		SMSReceive_Month[playerid][i] = 0;
		SMSReceive_Day[playerid][i] = 0;
		SMSReceive_Hour[playerid][i] = 0;
		SMSReceive_Minute[playerid][i] = 0;
		strmid(SMSReceive_Content[playerid][i], "", 0, 128, 128);
	}

	for(new i = 0; i < MAX_NUM_NOTE; i ++)
	{
		NumberNote_Create[playerid][i] = 0;
		NumberNote_Index[playerid][i] = -1;
		NumberNote_CallNum[playerid][i] = 0;
		strmid(NumberNote_Name[playerid][i], "", 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
		strmid(NumberNote_NickName[playerid][i], "", 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
	}
	
	for(new i = 0; i < MAX_MP3; i ++)
	{
		playerMP3_Create[playerid][i] = 0;
		playerMP3_Index[playerid][i] = -1;
		strmid(playerMP3_Name[playerid][i], "", 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
		strmid(playerMP3_Title[playerid][i], "", 0, 50, 50);
		strmid(playerMP3_Url[playerid][i], "", 0, 128, 128);
	}

	InvenSelectSlot[playerid] = -1;
	for(new i = 0; i < MAX_ITEM_SLOT; i ++)
	{
		for(new a = 0; a <MAX_INVEN_ITEM; a ++)
		{
			InvenItem[playerid][i][a] = 0;
			InvenItemNum[playerid][i][a] = 0;
		}
	}
	return 1;
}

stock CreateTabel_Column() 
{
	if(ServerDBConnect == 1)
	{
	    print("Create Table & Column [1~180 SECOND]");
	    new query[200], string[50];

		//===================================== CREATE TABLES =====================================//
	    mysql_format(MySQL, query, sizeof(query), "CREATE TABLE IF NOT EXISTS %s(tempcolumn int(1)) ENGINE=innoDB default character set utf8 collate utf8_general_ci",MySQL_USER);
		mysql_query(MySQL, query, false);
		if(strlen(query) > sizeof(query)) printf("ERROR : MySQL %s Table Create Array Lack", MySQL_USER);

		mysql_format(MySQL, query, sizeof(query), "CREATE TABLE IF NOT EXISTS %s(tempcolumn int(1)) ENGINE=innoDB character set utf8 collate utf8_general_ci",MySQL_VEHICLE);
		mysql_query(MySQL, query, false);
		if(strlen(query) > sizeof(query)) printf("ERROR : MySQL %s Table Create Array Lack", MySQL_VEHICLE);

		mysql_format(MySQL, query, sizeof(query), "CREATE TABLE IF NOT EXISTS %s(tempcolumn int(1)) ENGINE=innoDB character set utf8 collate utf8_general_ci",MySQL_BUILD);
		mysql_query(MySQL, query, false);
		if(strlen(query) > sizeof(query)) printf("ERROR : MySQL %s Table Create Array Lack", MySQL_BUILD);
		
        mysql_format(MySQL, query, sizeof(query), "CREATE TABLE IF NOT EXISTS %s(tempcolumn int(1)) ENGINE=innoDB character set utf8 collate utf8_general_ci",MySQL_SMS);
		mysql_query(MySQL, query, false);
		if(strlen(query) > sizeof(query)) printf("ERROR : MySQL %s Table Create Array Lack", MySQL_SMS);
		
		mysql_format(MySQL, query, sizeof(query), "CREATE TABLE IF NOT EXISTS %s(tempcolumn int(1)) ENGINE=innoDB character set utf8 collate utf8_general_ci",MySQL_NOTE);
		mysql_query(MySQL, query, false);
		if(strlen(query) > sizeof(query)) printf("ERROR : MySQL %s Table Create Array Lack", MySQL_NOTE);
		
		mysql_format(MySQL, query, sizeof(query), "CREATE TABLE IF NOT EXISTS %s(tempcolumn int(1)) ENGINE=innoDB character set utf8 collate utf8_general_ci",MySQL_NUM_NOTE);
		mysql_query(MySQL, query, false);
		if(strlen(query) > sizeof(query)) printf("ERROR : MySQL %s Table Create Array Lack", MySQL_NUM_NOTE);
		
		mysql_format(MySQL, query, sizeof(query), "CREATE TABLE IF NOT EXISTS %s(tempcolumn int(1)) ENGINE=innoDB character set utf8 collate utf8_general_ci",MySQL_MP3);
		mysql_query(MySQL, query, false);
		if(strlen(query) > sizeof(query)) printf("ERROR : MySQL %s Table Create Array Lack", MySQL_MP3);
		
		mysql_format(MySQL, query, sizeof(query), "CREATE TABLE IF NOT EXISTS %s(tempcolumn int(1)) ENGINE=innoDB character set utf8 collate utf8_general_ci",MySQL_ATM);
		mysql_query(MySQL, query, false);
		if(strlen(query) > sizeof(query)) printf("ERROR : MySQL %s Table Create Array Lack", MySQL_ATM);
		//===================================== MySQL_USER =====================================// // psave
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,ADD PRIMARY KEY (`id`);",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pPassword` varchar(128)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pName` varchar(25)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pAge` INT(3)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pMoney` INT(10)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pBornYear` INT(4)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pBornMonth` INT(2)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pBornDay` INT(2)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pSex` INT(1)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pSkin` INT(3)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pCountry` INT(2)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pPosX` FLOAT(8,4)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pPosY` FLOAT(8,4)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pPosZ` FLOAT(8,4)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pAngle` FLOAT(8,4)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pAdmin` INT(5)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pAdminName` TEXT",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pInterior` INT(8)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pVirtualWorld` INT(8)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pTutorial` INT(1)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pChatBan` INT(1)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pHealth` FLOAT(8,4)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pArmour` FLOAT(8,4)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pHungry` FLOAT(8,4)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pEnergy` FLOAT(8,4)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pPhoneNumber` INT(8)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pPhonePower` INT(1)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pAccountNum` INT(8)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pAccountMoney` INT(10)",MySQL_USER); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `pShopMode` INT(2)",MySQL_USER); mysql_query(MySQL, query, false);
		
		for(new slot = 0; slot < MAX_ITEM_SLOT; slot ++)
		{
		    for(new item = 0; item < MAX_INVEN_ITEM; item ++)
		    {
		        format(string, sizeof(string), "InvenItem%d_%d",slot, item); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(5)",MySQL_USER, string); mysql_query(MySQL, query, false);
		        format(string, sizeof(string), "InvenItemNum%d_%d",slot, item); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(5)",MySQL_USER, string); mysql_query(MySQL, query, false);
			}
		}
		//===================================== MySQL_SMS =====================================//
		format(string, sizeof(string), "SMSPhoneNumber"); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(8) UNSIGNED NOT NULL, ADD PRIMARY KEY (`SMSPhoneNumber`);",MySQL_SMS, string); mysql_query(MySQL, query, false);
		for(new i = 0; i < MAX_SMS; i ++)
		{
			format(string, sizeof(string), "SMSSend_CallNum_%d",i); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(8)",MySQL_SMS, string); mysql_query(MySQL, query, false);
			format(string, sizeof(string), "SMSSend_Index_%d",i); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(3)",MySQL_SMS, string); mysql_query(MySQL, query, false);
			format(string, sizeof(string), "SMSSend_Date_%d",i); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` DATETIME",MySQL_SMS, string); mysql_query(MySQL, query, false);
			/*
	        format(string, sizeof(string), "SMSSend_Year_%d",i); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(4)",MySQL_SMS, string); mysql_query(MySQL, query, false);
	        format(string, sizeof(string), "SMSSend_Month_%d",i); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(2)",MySQL_SMS, string); mysql_query(MySQL, query, false);
	        format(string, sizeof(string), "SMSSend_Day_%d",i); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(2)",MySQL_SMS, string); mysql_query(MySQL, query, false);
	        format(string, sizeof(string), "SMSSend_Hour_%d",i); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(2)",MySQL_SMS, string); mysql_query(MySQL, query, false);
	        format(string, sizeof(string), "SMSSend_Minute_%d",i); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(2)",MySQL_SMS, string); mysql_query(MySQL, query, false);
	        */
		    format(string, sizeof(string), "SMSSend_Content_%d",i); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` varchar(128)",MySQL_SMS, string); mysql_query(MySQL, query, false);
		    
		    format(string, sizeof(string), "SMSReceive_CallNum_%d",i); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(8)",MySQL_SMS, string); mysql_query(MySQL, query, false);
		    format(string, sizeof(string), "SMSReceive_HitChk_%d",i); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(1)",MySQL_SMS, string); mysql_query(MySQL, query, false);
			format(string, sizeof(string), "SMSReceive_Index_%d",i); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(3)",MySQL_SMS, string); mysql_query(MySQL, query, false);
			format(string, sizeof(string), "SMSReceive_Date_%d",i); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` DATETIME",MySQL_SMS, string); mysql_query(MySQL, query, false);
			/*
		    format(string, sizeof(string), "SMSReceive_Year_%d",i); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(4)",MySQL_SMS, string); mysql_query(MySQL, query, false);
		    format(string, sizeof(string), "SMSReceive_Month_%d",i); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(2)",MySQL_SMS, string); mysql_query(MySQL, query, false);
		    format(string, sizeof(string), "SMSReceive_Day_%d",i); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(2)",MySQL_SMS, string); mysql_query(MySQL, query, false);
		    format(string, sizeof(string), "SMSReceive_Hour_%d",i); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(2)",MySQL_SMS, string); mysql_query(MySQL, query, false);
		    format(string, sizeof(string), "SMSReceive_Minute_%d",i); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(2)",MySQL_SMS, string); mysql_query(MySQL, query, false);
			*/
		    format(string, sizeof(string), "SMSReceive_Content_%d",i); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` varchar(128)",MySQL_SMS, string); mysql_query(MySQL, query, false);
		}
		//===================================== MySQL_NOTE =====================================//
		format(string, sizeof(string), "id"); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,ADD PRIMARY KEY (`id`);",MySQL_NOTE, string); mysql_query(MySQL, query, false);
		format(string, sizeof(string), "privateNote_Name"); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` varchar(25)",MySQL_NOTE, string); mysql_query(MySQL, query, false);
	    format(string, sizeof(string), "privateNote_Create"); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(1)",MySQL_NOTE, string); mysql_query(MySQL, query, false);
	    format(string, sizeof(string), "privateNote_Index"); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(3)",MySQL_NOTE, string); mysql_query(MySQL, query, false);
		format(string, sizeof(string), "privateNote_Date"); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` DATETIME",MySQL_NOTE, string); mysql_query(MySQL, query, false);
	    format(string, sizeof(string), "privateNote_Content"); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` varchar(128)",MySQL_NOTE, string); mysql_query(MySQL, query, false);
		//===================================== MySQL_NUM_NOTE =====================================//
		format(string, sizeof(string), "id"); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,ADD PRIMARY KEY (`id`);",MySQL_NUM_NOTE, string); mysql_query(MySQL, query, false);
	    format(string, sizeof(string), "NumberNote_Name"); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` varchar(25)",MySQL_NUM_NOTE, string); mysql_query(MySQL, query, false);
	    format(string, sizeof(string), "NumberNote_NickName"); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` varchar(50)",MySQL_NUM_NOTE, string); mysql_query(MySQL, query, false);
	    format(string, sizeof(string), "NumberNote_Index"); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(3)",MySQL_NUM_NOTE, string); mysql_query(MySQL, query, false);
	    format(string, sizeof(string), "NumberNote_CallNum"); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(8)",MySQL_NUM_NOTE, string); mysql_query(MySQL, query, false);
	    format(string, sizeof(string), "NumberNote_Create"); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(1)",MySQL_NUM_NOTE, string); mysql_query(MySQL, query, false);
	    //===================================== MySQL_MP3 =====================================//
	    format(string, sizeof(string), "id"); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,ADD PRIMARY KEY (`id`);",MySQL_MP3, string); mysql_query(MySQL, query, false);
        format(string, sizeof(string), "playerMP3_Name"); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` varchar(25)",MySQL_MP3, string); mysql_query(MySQL, query, false);
        format(string, sizeof(string), "playerMP3_Title"); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` varchar(50)",MySQL_MP3, string); mysql_query(MySQL, query, false);
        format(string, sizeof(string), "playerMP3_Index"); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(3)",MySQL_MP3, string); mysql_query(MySQL, query, false);
		format(string, sizeof(string), "playerMP3_Create"); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` INT(1)",MySQL_MP3, string); mysql_query(MySQL, query, false);
	    format(string, sizeof(string), "playerMP3_Url"); mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `%s` varchar(128)",MySQL_MP3, string); mysql_query(MySQL, query, false);
		//===================================== MySQL_VEHICLE =====================================//
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,ADD PRIMARY KEY (`id`);",MySQL_VEHICLE); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `vCreate` INT(1)",MySQL_VEHICLE); mysql_query(MySQL, query, false);
        mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `vModel` INT(3)",MySQL_VEHICLE); mysql_query(MySQL, query, false);
        mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `vOwner` VARCHAR(25)",MySQL_VEHICLE); mysql_query(MySQL, query, false);
        mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `vPlate` VARCHAR(50)",MySQL_VEHICLE); mysql_query(MySQL, query, false);
        mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `vEngine` INT(1)",MySQL_VEHICLE); mysql_query(MySQL, query, false);
        mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `vLock` INT(1)",MySQL_VEHICLE); mysql_query(MySQL, query, false);
        mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `vFaction` INT(3)",MySQL_VEHICLE); mysql_query(MySQL, query, false);
        mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `vFactionIndex` INT(3)",MySQL_VEHICLE); mysql_query(MySQL, query, false);
        mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `vFuel` FLOAT(8,4)",MySQL_VEHICLE); mysql_query(MySQL, query, false);
        mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `vBlow` INT(1)",MySQL_VEHICLE); mysql_query(MySQL, query, false);
        mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `vColor_0` INT(3)",MySQL_VEHICLE); mysql_query(MySQL, query, false);
        mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `vColor_1` INT(3)",MySQL_VEHICLE); mysql_query(MySQL, query, false);
        mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `vHealth` FLOAT(8,4)",MySQL_VEHICLE); mysql_query(MySQL, query, false);
        mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `vPosition_0` FLOAT(8,4)",MySQL_VEHICLE); mysql_query(MySQL, query, false);
        mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `vPosition_1` FLOAT(8,4)",MySQL_VEHICLE); mysql_query(MySQL, query, false);
        mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `vPosition_2` FLOAT(8,4)",MySQL_VEHICLE); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `vAngle` FLOAT(8,4)",MySQL_VEHICLE); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `vInterior` INT(5)",MySQL_VEHICLE); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `vVirtualWorld` INT(5)",MySQL_VEHICLE); mysql_query(MySQL, query, false);


		/* 튜닝시 저장할 변수 */
		/*
		vSpoiler,
		vHood,
		vRoof,
		vSkirt,
		vLamps,
		vNitro,
		vExhaust,
		vWheels,
		vStereo,
		vHydraulics,
		vFront_Bumper,
		vRear_Bumper,
		vRight_Vent,
		vLeft_Vent
  		*/
		/* 튜닝시 저장할 변수 */
		//===================================== MySQL_BUILD =====================================//
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,ADD PRIMARY KEY (`id`);",MySQL_BUILD); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `bName` varchar(128)",MySQL_BUILD); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `bCreate` INT(10)",MySQL_BUILD); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `bNumber` INT(10)",MySQL_BUILD); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `bOwner` varchar(25)",MySQL_BUILD); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `bType` INT(10)",MySQL_BUILD); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `bIsSell` INT(10)",MySQL_BUILD); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `bInInterior` INT(10)",MySQL_BUILD); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `bOutInterior` INT(10)",MySQL_BUILD); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `bInVirtualWorld` INT(10)",MySQL_BUILD); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `bOutVirtualWorld` INT(10)",MySQL_BUILD); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `bInPos_0` FLOAT(8,4)",MySQL_BUILD); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `bInPos_1` FLOAT(8,4)",MySQL_BUILD); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `bInPos_2` FLOAT(8,4)",MySQL_BUILD); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `bOutPos_0` FLOAT(8,4)",MySQL_BUILD); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `bOutPos_1` FLOAT(8,4)",MySQL_BUILD); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `bOutPos_2` FLOAT(8,4)",MySQL_BUILD); mysql_query(MySQL, query, false);
		//===================================== MySQL_ATM =====================================//
		//mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,ADD PRIMARY KEY (`id`);",MySQL_ATM); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `atm_index` INT(10) UNSIGNED NOT NULL, ADD PRIMARY KEY (`atm_index`);",MySQL_ATM); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `atm_create` INT(1)",MySQL_ATM); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `atm_objectid` INT(8)",MySQL_ATM); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `atm_virtualworld` INT(10)",MySQL_ATM); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `atm_position_0` FLOAT(8,4)",MySQL_ATM); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `atm_position_1` FLOAT(8,4)",MySQL_ATM); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `atm_position_2` FLOAT(8,4)",MySQL_ATM); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `atm_position_3` FLOAT(8,4)",MySQL_ATM); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `atm_position_4` FLOAT(8,4)",MySQL_ATM); mysql_query(MySQL, query, false);
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` ADD COLUMN `atm_position_5` FLOAT(8,4)",MySQL_ATM); mysql_query(MySQL, query, false);
		//===================================== MySQL Temp Delete =====================================//
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` DROP COLUMN tempcolumn",MySQL_USER);
		mysql_query(MySQL, query, false);

		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` DROP COLUMN tempcolumn",MySQL_VEHICLE);
		mysql_query(MySQL, query, false);

		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` DROP COLUMN tempcolumn",MySQL_BUILD);
		mysql_query(MySQL, query, false);
		
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` DROP COLUMN tempcolumn",MySQL_SMS);
		mysql_query(MySQL, query, false);
		
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` DROP COLUMN tempcolumn",MySQL_NOTE);
		mysql_query(MySQL, query, false);
		
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` DROP COLUMN tempcolumn",MySQL_NUM_NOTE);
		mysql_query(MySQL, query, false);
		
		mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` DROP COLUMN tempcolumn",MySQL_MP3);
		mysql_query(MySQL, query, false);

    	mysql_format(MySQL, query, sizeof(query), "ALTER TABLE `%s` DROP COLUMN tempcolumn",MySQL_ATM);
		mysql_query(MySQL, query, false);

		print("Success Create Table & Column");
		return 1;
	}
	return 0;
}
stock split(const strsrc[], strdest[][], delimiter)
{
	new i,li,aNum,len;
	while(i <= strlen(strsrc))
	{
	    if(strsrc[i]==delimiter || i==strlen(strsrc))
		{
	        len = strmid(strdest[aNum], strsrc, li, i, 128);
	        strdest[aNum][len] = 0;
	        li = i+1;
	        aNum++;
		}
		i++;
	}
	return 1;
}

stock strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[25];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

//========================= chat function =========================//
stock ClearChat(playerid, size)
{
	for(new i = 0; i < size; i ++)
	{
	    SendClientMessage(playerid, -1, " ");
	}
	return 1;
}

stock SendAllMessage(text[], color)
{
    for(new i = 0; i < MAX_PLAYERS; i ++)
	{
	    if(IsPlayerConnected(i))
	    {
	    	SendClientMessage(i, color, text);
	    }
	}
}

stock SendMessage(playerid, Message[])
{
	new string[128];
	format(string, sizeof(string), "≫ %s", Message);
	SendClientMessage(playerid, COLOR_WHITE, string);
	return 1;
}

stock SendErrorMessage(playerid, Message[])
{
	new string[128];
	format(string, sizeof(string), "≫ %s", Message);
	SendClientMessage(playerid, COLOR_ERROR, string);
	return 1;
}

stock SendAdminMessage(Message[], level = 1, color = COLOR_ADMIN)
{
	for(new i = 0; i < MAX_PLAYERS; i ++)
	{
	    if(IsPlayerLogin(i))
	    {
	        if(PlayerInfo[i][pAdmin] >= level)
	        {
	            SendClientMessage(i, color, Message);
	        }
	    }
	}
	return 1;
}
//================================================================//

stock SetPlayerInteriorEx(playerid, InteriorID)
{
	PlayerInfo[playerid][pInterior] = InteriorID;
 	SetPlayerInterior(playerid, InteriorID);
 	return 1;
}

stock SetPlayerVirtualWorldEx(playerid, VirtualWorldID)
{
    PlayerInfo[playerid][pVirtualWorld] = VirtualWorldID;
    SetPlayerVirtualWorld(playerid, VirtualWorldID);
    return 1;
}

stock RegDialogue(playerid, rState)
{
    new title[52], string[256];
    if(rState == 1)
    {
	    format(title, sizeof(title), "회원가입 - %s",PlayerNameEx(playerid));
		format(string, sizeof(string), ""#C_WHITE"The Unlimited Role Play에 오신 것을 환영합니다, %s\n\
	                                    해당 닉네임으로 등록된 계정이 없습니다.\n\
	                                    하단에 원하는 비밀번호를 입력해 계정을 생성해주세요.", PlayerNameEx(playerid));
	    ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, title, string, "회원가입", "종료");
	    
	    PlayerInfo[playerid][pRegState] = 1;
	}
	else if(rState == 2)
	{
	    format(title, sizeof(title), "회원가입 - %s",PlayerNameEx(playerid));
		format(string, sizeof(string), ""#C_WHITE"앞으로 사용하실 닉네임은 %s입니다.\n\
	                                    비밀번호 확인을 위해 입력한 비밀번호를 재입력해주세요.", PlayerNameEx(playerid));
	    ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, title, string, "회원가입", "뒤로가기");
	    
	    PlayerInfo[playerid][pRegState] = 2;
	}
    return 1;
}

stock LogDialogue(playerid)
{
    new title[52], string[256];
    format(title, sizeof(title), "로그인 - %s",PlayerNameEx(playerid));
	format(string, sizeof(string), ""#C_WHITE"The Unlimited Role Play에 오신 것을 환영합니다, %s\n\
                                    해당 닉네임으로 등록된 계정이 있습니다.\n\
                                    하단에 비밀번호를 입력해 로그인해주세요.", PlayerNameEx(playerid));
	ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, title, string, "로그인", "종료");
	return 1;
}

stock PlayerNameEx(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

stock SetWeatherEx(weather)
{
    SerWeather = weather;
    SetWeather(SerWeather);
	return 1;
}

stock RemoveObject(playerid)
{
	//=============================== 스폰 장소 ===============================//
    RemoveBuildingForPlayer(playerid, 3718, 693.859, -1626.429, 6.148, 0.250);
	RemoveBuildingForPlayer(playerid, 3719, 690.335, -1646.546, 6.562, 0.250);
	RemoveBuildingForPlayer(playerid, 730, 701.304, -1621.546, 2.187, 0.250);
	RemoveBuildingForPlayer(playerid, 730, 694.445, -1658.476, 0.304, 0.250);
	RemoveBuildingForPlayer(playerid, 733, 684.968, -1633.625, 1.500, 0.250);
	RemoveBuildingForPlayer(playerid, 762, 666.703, -1701.812, 16.085, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 668.601, -1685.023, 12.585, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 666.476, -1684.617, 12.835, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 664.382, -1684.851, 12.835, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 661.632, -1684.726, 12.835, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 671.031, -1685.421, 12.164, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 651.242, -1631.062, 13.437, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 651.492, -1660.250, 13.773, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 655.242, -1660.375, 13.773, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 654.273, -1643.171, 13.390, 0.250);
	RemoveBuildingForPlayer(playerid, 762, 683.578, -1664.398, 3.742, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.187, -1691.015, 2.468, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.179, -1696.203, 2.468, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.187, -1705.085, 2.468, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.187, -1702.906, 2.468, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.179, -1708.093, 2.468, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.179, -1710.796, 2.468, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.187, -1685.617, 2.468, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.187, -1683.445, 2.468, 0.250);
	RemoveBuildingForPlayer(playerid, 762, 686.546, -1676.796, 3.742, 0.250);
	RemoveBuildingForPlayer(playerid, 762, 695.937, -1670.632, 3.742, 0.250);
	RemoveBuildingForPlayer(playerid, 762, 685.359, -1658.632, 3.742, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.187, -1658.523, 2.468, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.179, -1663.843, 2.085, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.179, -1661.531, 2.468, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 696.226, -1655.273, 2.492, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 692.507, -1656.070, 2.492, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.187, -1656.343, 2.468, 0.250);
	RemoveBuildingForPlayer(playerid, 3640, 690.335, -1646.546, 6.562, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.187, -1649.000, 2.468, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.187, -1646.820, 2.468, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.179, -1654.320, 2.085, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.179, -1652.007, 2.468, 0.250);
	RemoveBuildingForPlayer(playerid, 3639, 693.859, -1626.429, 6.148, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 697.742, -1637.273, 2.468, 0.250);
	RemoveBuildingForPlayer(playerid, 1408, 699.843, -1635.867, 3.015, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.179, -1637.328, 2.468, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.179, -1639.640, 2.085, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.179, -1619.906, 2.468, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.179, -1622.421, 2.468, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.187, -1632.140, 2.468, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.187, -1634.320, 2.468, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 766.476, -1706.062, 3.648, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 766.953, -1708.632, 3.648, 0.250);
	RemoveBuildingForPlayer(playerid, 760, 782.289, -1698.132, 12.500, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 765.382, -1686.304, 2.968, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 768.351, -1687.531, 2.968, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 765.640, -1663.328, 2.898, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 764.312, -1663.257, 2.898, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 767.765, -1646.937, 3.437, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 766.234, -1645.601, 3.437, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 761.289, -1625.148, 12.554, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 765.328, -1642.789, 2.898, 0.250);
	RemoveBuildingForPlayer(playerid, 762, 768.421, -1632.726, 9.156, 0.250);
	RemoveBuildingForPlayer(playerid, 762, 771.914, -1621.523, 14.781, 0.250);
	RemoveBuildingForPlayer(playerid, 1297, 675.750, -1540.429, 16.921, 0.250);
	RemoveBuildingForPlayer(playerid, 621, 671.250, -1508.609, 12.656, 0.250);
	RemoveBuildingForPlayer(playerid, 1297, 674.078, -1514.632, 16.921, 0.250);
	RemoveBuildingForPlayer(playerid, 1297, 674.078, -1484.921, 16.921, 0.250);
	RemoveBuildingForPlayer(playerid, 1297, 675.601, -1457.882, 16.921, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 680.906, -1605.617, 12.968, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 680.906, -1603.359, 12.968, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 681.085, -1601.109, 12.968, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 680.828, -1598.859, 12.968, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 683.414, -1598.859, 12.968, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 678.781, -1512.796, 13.390, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 677.664, -1485.781, 7.679, 0.250);
	RemoveBuildingForPlayer(playerid, 762, 680.945, -1522.906, 15.742, 0.250);
	RemoveBuildingForPlayer(playerid, 762, 680.945, -1496.101, 15.742, 0.250);
	RemoveBuildingForPlayer(playerid, 762, 680.945, -1468.625, 15.742, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 682.304, -1530.820, 8.156, 0.250);
	RemoveBuildingForPlayer(playerid, 621, 682.648, -1533.828, 10.453, 0.250);
	RemoveBuildingForPlayer(playerid, 621, 682.570, -1512.242, 13.109, 0.250);
	RemoveBuildingForPlayer(playerid, 621, 682.648, -1508.484, 10.453, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 681.843, -1504.031, 13.906, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 682.859, -1464.921, 11.382, 0.250);
	RemoveBuildingForPlayer(playerid, 621, 681.640, -1485.039, 12.703, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.195, -1605.617, 12.968, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 698.609, -1598.859, 12.968, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 701.195, -1598.859, 12.968, 0.250);
	RemoveBuildingForPlayer(playerid, 621, 686.171, -1442.859, 10.453, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 776.343, -1602.968, 12.554, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 777.437, -1599.843, 12.296, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 775.296, -1598.046, 12.296, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 777.875, -1598.046, 12.296, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 763.148, -1598.140, 12.070, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 765.312, -1598.437, 12.070, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 769.812, -1755.085, 11.812, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 777.125, -1756.234, 11.812, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 782.656, -1745.703, 12.554, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 783.671, -1756.156, 12.429, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 797.218, -1741.539, 12.429, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 797.710, -1743.382, 12.429, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 666.851, -1725.656, 12.453, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 770.242, -1737.218, 11.273, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 767.648, -1737.476, 11.273, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 797.375, -1740.679, 12.554, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 797.835, -1739.054, 12.429, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 646.132, -1720.835, 12.835, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 669.375, -1721.828, 12.015, 0.250);
	RemoveBuildingForPlayer(playerid, 762, 695.617, -1720.859, 5.710, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 674.890, -1722.015, 8.054, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 767.648, -1720.640, 11.273, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 770.242, -1720.390, 11.273, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 774.054, -1720.640, 11.703, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 778.070, -1720.390, 11.703, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 673.421, -1719.312, 7.515, 0.250);
	RemoveBuildingForPlayer(playerid, 762, 775.304, -1717.742, 5.890, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 766.953, -1716.000, 3.648, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 794.398, -1715.984, 12.375, 0.250);
	RemoveBuildingForPlayer(playerid, 759, 791.171, -1716.601, 12.375, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 702.9453, -1598.4219, 12.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 759, 701.1953, -1598.8594, 12.9688, 0.25);
	//=============================== 스폰 장소 ===============================//
	
	//=============================== 캠에 보일 장소 =================================//
	RemoveBuildingForPlayer(playerid, 5530, 2112.9375, -1797.0938, 19.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 5535, 1918.8516, -1776.3281, 16.9766, 0.25);
	RemoveBuildingForPlayer(playerid, 1524, 1910.1641, -1779.6641, 18.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 5681, 1921.4844, -1778.9141, 18.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 5409, 1918.8516, -1776.3281, 16.9766, 0.25);
	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1778.4531, 14.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1774.3125, 14.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 955, 1928.7344, -1772.4453, 12.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1771.3438, 14.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 1676, 1941.6563, -1767.2891, 14.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 1522, 2105.9219, -1807.2500, 12.5156, 0.25);
	RemoveBuildingForPlayer(playerid, 5418, 2112.9375, -1797.0938, 19.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 17761, 2317.5156, -1639.9453, 18.2422, 0.25);
	RemoveBuildingForPlayer(playerid, 1498, 2309.8125, -1642.6641, 13.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 17577, 2317.5156, -1639.9453, 18.2422, 0.25);
	RemoveBuildingForPlayer(playerid, 17578, 2318.1719, -1645.4609, 20.1797, 0.25);
	//=============================== 캠에 보일 장소 =================================//
	
	//=============================== 은행 오브젝트 =================================//
	RemoveBuildingForPlayer(playerid, 4579, 1666.492, -1246.179, 123.085, 0.250);
	RemoveBuildingForPlayer(playerid, 1525, 1687.226, -1239.125, 15.812, 0.250);
	RemoveBuildingForPlayer(playerid, 4717, 1666.492, -1246.179, 123.085, 0.250);
	RemoveBuildingForPlayer(playerid, 4564, 1666.492, -1246.179, 123.085, 0.250);
	RemoveBuildingForPlayer(playerid, 717, 1698.195, -1270.359, 13.968, 0.250);
	RemoveBuildingForPlayer(playerid, 717, 1698.648, -1258.359, 13.968, 0.250);
	RemoveBuildingForPlayer(playerid, 717, 1698.789, -1246.359, 14.265, 0.250);
	RemoveBuildingForPlayer(playerid, 717, 1698.757, -1233.820, 14.265, 0.250);
	RemoveBuildingForPlayer(playerid, 717, 1698.757, -1221.351, 14.265, 0.250);
	//=============================== 은행 오브젝트 =================================//
	
	/*
	//=============================== 일반 차량판매소 오브젝트 =================================//
	RemoveBuildingForPlayer(playerid, 1307, 787.6719, -1384.3828, 12.7813, 0.25);
    RemoveBuildingForPlayer(playerid, 6491, 717.4844, -1357.3047, 20.2969, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 665.8125, -1390.2422, 16.3125, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 778.8594, -1391.1563, 16.3125, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 723.2969, -1390.2422, 16.3125, 0.25);
    RemoveBuildingForPlayer(playerid, 1689, 650.8359, -1377.6641, 21.7578, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 642.0938, -1359.8203, 16.2734, 0.25);
    RemoveBuildingForPlayer(playerid, 1689, 650.8359, -1356.5859, 21.7578, 0.25);
    RemoveBuildingForPlayer(playerid, 1226, 642.0938, -1334.8516, 16.2734, 0.25);
    RemoveBuildingForPlayer(playerid, 1689, 650.8359, -1338.2422, 21.7578, 0.25);
    RemoveBuildingForPlayer(playerid, 1635, 677.1953, -1328.8750, 25.1094, 0.25);
    RemoveBuildingForPlayer(playerid, 1689, 745.5859, -1381.1094, 25.8750, 0.25);
    RemoveBuildingForPlayer(playerid, 1689, 751.3359, -1368.0313, 25.8750, 0.25);
    RemoveBuildingForPlayer(playerid, 6490, 717.4844, -1357.3047, 20.2969, 0.25);
    RemoveBuildingForPlayer(playerid, 6516, 717.6875, -1357.2813, 18.0469, 0.25);
    RemoveBuildingForPlayer(playerid, 1635, 696.1953, -1328.8750, 25.1094, 0.25);
    RemoveBuildingForPlayer(playerid, 1635, 702.2344, -1328.8750, 25.1094, 0.25);
    RemoveBuildingForPlayer(playerid, 1635, 721.2109, -1328.8750, 25.1094, 0.25);
    RemoveBuildingForPlayer(playerid, 1415, 732.8516, -1332.8984, 12.6875, 0.25);
    RemoveBuildingForPlayer(playerid, 1439, 732.7266, -1341.7734, 12.6328, 0.25);
	//=============================== 일반 차량판매소 오브젝트 =================================//
	*/
	
	//=============================== 소방서 오브젝트 =================================//
	RemoveBuildingForPlayer(playerid, 6147, 743.156, -1428.656, 16.726, 0.250);
	RemoveBuildingForPlayer(playerid, 6193, 717.195, -1490.984, 15.757, 0.250);
	RemoveBuildingForPlayer(playerid, 1529, 730.445, -1482.007, 2.250, 0.250);
	//RemoveBuildingForPlayer(playerid, 6256, 721.437, -1450.945, 10.195, 0.250);
	//RemoveBuildingForPlayer(playerid, 6133, 721.437, -1450.945, 10.195, 0.250);
	RemoveBuildingForPlayer(playerid, 6134, 743.156, -1428.656, 16.726, 0.250);
	//=============================== 소방서 오브젝트 =================================//
	
	//=============================== 병원, 차 판매소 오브젝트 =================================//
	RemoveBuildingForPlayer(playerid, 1529, 1098.812, -1292.546, 17.140, 0.250);
	RemoveBuildingForPlayer(playerid, 5919, 1200.906, -1337.992, 12.398, 0.250);
	RemoveBuildingForPlayer(playerid, 5928, 1309.914, -1330.132, 25.187, 0.250);
	RemoveBuildingForPlayer(playerid, 5930, 1134.250, -1338.078, 23.156, 0.250);
	RemoveBuildingForPlayer(playerid, 5931, 1114.312, -1348.101, 17.984, 0.250);
	RemoveBuildingForPlayer(playerid, 5933, 1281.437, -1337.953, 12.375, 0.250);
	RemoveBuildingForPlayer(playerid, 5934, 1076.710, -1358.093, 15.445, 0.250);
	RemoveBuildingForPlayer(playerid, 5935, 1120.156, -1303.453, 18.570, 0.250);
	RemoveBuildingForPlayer(playerid, 5936, 1090.054, -1310.531, 17.546, 0.250);
	RemoveBuildingForPlayer(playerid, 716, 1068.640, -1365.773, 12.359, 0.250);
	RemoveBuildingForPlayer(playerid, 1440, 1085.703, -1361.023, 13.265, 0.250);
	RemoveBuildingForPlayer(playerid, 5731, 1076.710, -1358.093, 15.445, 0.250);
	RemoveBuildingForPlayer(playerid, 5788, 1080.984, -1305.523, 16.359, 0.250);
	RemoveBuildingForPlayer(playerid, 5787, 1090.054, -1310.531, 17.546, 0.250);
	RemoveBuildingForPlayer(playerid, 5764, 1065.140, -1270.578, 25.710, 0.250);
	RemoveBuildingForPlayer(playerid, 5810, 1114.312, -1348.101, 17.984, 0.250);
	RemoveBuildingForPlayer(playerid, 5993, 1110.898, -1328.812, 13.851, 0.250);
	RemoveBuildingForPlayer(playerid, 5811, 1131.195, -1380.421, 17.070, 0.250);
	RemoveBuildingForPlayer(playerid, 5708, 1134.250, -1338.078, 23.156, 0.250);
	RemoveBuildingForPlayer(playerid, 1440, 1141.984, -1346.109, 13.265, 0.250);
	RemoveBuildingForPlayer(playerid, 1440, 1148.679, -1385.187, 13.265, 0.250);
	RemoveBuildingForPlayer(playerid, 617, 1178.601, -1332.070, 12.890, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 1184.007, -1353.500, 12.578, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 1184.007, -1343.265, 12.578, 0.250);
	RemoveBuildingForPlayer(playerid, 5737, 1120.156, -1303.453, 18.570, 0.250);
	RemoveBuildingForPlayer(playerid, 618, 1177.734, -1315.664, 13.296, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 1184.812, -1292.914, 12.578, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 1184.812, -1303.148, 12.578, 0.250);
	RemoveBuildingForPlayer(playerid, 1283, 1190.304, -1389.804, 15.500, 0.250);
	RemoveBuildingForPlayer(playerid, 1297, 1190.773, -1383.273, 15.945, 0.250);
	RemoveBuildingForPlayer(playerid, 1297, 1190.773, -1350.414, 15.945, 0.250);
	RemoveBuildingForPlayer(playerid, 1297, 1210.804, -1367.382, 15.773, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 1222.664, -1374.609, 12.296, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 1240.921, -1374.609, 12.296, 0.250);
	RemoveBuildingForPlayer(playerid, 1297, 1190.773, -1320.859, 15.945, 0.250);
	RemoveBuildingForPlayer(playerid, 5794, 1200.906, -1337.992, 12.398, 0.250);
	RemoveBuildingForPlayer(playerid, 1297, 1210.804, -1337.835, 15.773, 0.250);
	RemoveBuildingForPlayer(playerid, 1297, 1190.773, -1299.742, 15.945, 0.250);
	RemoveBuildingForPlayer(playerid, 1283, 1194.796, -1290.851, 15.710, 0.250);
	RemoveBuildingForPlayer(playerid, 1297, 1210.804, -1304.968, 15.773, 0.250);
	RemoveBuildingForPlayer(playerid, 5809, 1281.437, -1337.953, 12.375, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 1321.523, -1374.429, 12.585, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 1292.000, -1374.296, 12.367, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 1300.585, -1374.296, 12.367, 0.250);
	RemoveBuildingForPlayer(playerid, 5704, 1309.914, -1330.132, 25.187, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 1329.476, -1374.429, 12.585, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 1330.601, -1340.984, 6.109, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 1326.695, -1316.007, 8.726, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 1327.593, -1333.671, 6.109, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 1332.000, -1309.429, 8.726, 0.250);
	//=============================== 병원, 차 판매소 오브젝트 =================================//
	return 1;
}

stock GetPlayerFrontPos(playerid, &Float:x, &Float:y, &Float:z, Float:distance)
{
    new Float:angle;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, angle);
    x += (distance * floatsin(-angle, degrees));
    y += (distance * floatcos(-angle, degrees));
}

stock ShowContinent(playerid)
{
    new string[256], countryName[MAX_COUNTRY][52];
	new index = 0;

    for(new i = 0; i < MAX_COUNTRY; i ++) strmid(countryName[i], "None", 0, 52, 52);
	strmid(string, "", 0, 512, 512);
	for(new i = 0; i < MAX_COUNTRY; i ++)
	{
	    if(index != 0)
		{
			new index2 = index;
		    for(new a = 0; a < index2; a ++)
		    {
			    if(strcmp(CountryInfo[i][1], countryName[a], true) != 0 && strcmp(countryName[a], "None", true) != 0)
			    {
                    strmid(countryName[a], CountryInfo[i][1], 0, 52, 52);
			        if(!strlen(string)) format(string, sizeof(string), "%s", CountryInfo[i][1]);
		            else format(string, sizeof(string), "%s\n%s",string, CountryInfo[i][1]);
			        index++;
			    }
			}
		}
		else
		{
		    if(strcmp(CountryInfo[i][1], countryName[index], true) != 0)
			{
			    strmid(countryName[index], CountryInfo[i][1], 0, 52, 52);
		        if(!strlen(string)) format(string, sizeof(string), "%s", CountryInfo[i][1]);
	            else format(string, sizeof(string), "%s\n%s",string, CountryInfo[i][1]);
	            index++;
			}
		}
	}
	ShowPlayerDialog(playerid, DIALOG_CONTINENT, DIALOG_STYLE_LIST, "출생지 선택", string, "확인", "취소");
	return 1;
}

stock SendAroundMessage(playerid, Float:distance, Color1, Color2, Color3, Color4, Color5, Message[], type = 1, player = 1)
{
    new Float:Pos[3], Float:gPos[3], Float:vPos[3];
    new virtualworld = GetPlayerVirtualWorld(playerid);
	if(player == 1)
	{
		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	}
	else if(player == 2)
	{
		new vehicleid = playerid;
		GetVehiclePos(vehicleid, Pos[0], Pos[1], Pos[2]);
	}
	for(new giveplayerid = 0; giveplayerid < MAX_PLAYERS; giveplayerid ++)
	{
		if(IsPlayerConnected(giveplayerid) && IsPlayerLogin(giveplayerid))
		{
		    if(GetPlayerVirtualWorld(giveplayerid) == virtualworld)
		    {
		        GetPlayerPos(giveplayerid, gPos[0], gPos[1], gPos[2]);
		        vPos[0] = (Pos[0] - gPos[0]); vPos[1] = (Pos[1] - gPos[1]); vPos[2] = (Pos[2] - gPos[2]);
		        if(((vPos[0] < distance/16) && (vPos[0] > -distance/16)) && ((vPos[1] < distance/16) && (vPos[1] > -distance/16)) && ((vPos[2] < distance/16) && (vPos[2] > -distance/16)))
				{
				    SendClientMessage(giveplayerid, Color1, Message);
				}
				else if(((vPos[0] < distance/8) && (vPos[0] > -distance/8)) && ((vPos[1] < distance/8) && (vPos[1] > -distance/8)) && ((vPos[2] < distance/8) && (vPos[2] > -distance/8)))
				{
				    SendClientMessage(giveplayerid, Color2, Message);
				}
				else if(((vPos[0] < distance/4) && (vPos[0] > -distance/4)) && ((vPos[1] < distance/4) && (vPos[1] > -distance/4)) && ((vPos[2] < distance/4) && (vPos[2] > -distance/4)))
				{
				    SendClientMessage(giveplayerid, Color3, Message);
				}
				else if(((vPos[0] < distance/2) && (vPos[0] > -distance/2)) && ((vPos[1] < distance/2) && (vPos[1] > -distance/2)) && ((vPos[2] < distance/2) && (vPos[2] > -distance/2)))
				{
				    SendClientMessage(giveplayerid, Color4, Message);
				}
				else if(((vPos[0] < distance) && (vPos[0] > -distance)) && ((vPos[1] < distance) && (vPos[1] > -distance)) && ((vPos[2] < distance) && (vPos[2] > -distance)))
				{
				    SendClientMessage(giveplayerid, Color5, Message);
				}
				if(type == 1) print(Message);
		    }
		}
	}
	return 1;
}

stock DialogListStyle(text[])
{
	new chString[512];
	new string[256], string2[256];
	new lastIndex = -1;

	strmid(string, text, 0, 256, 256);
	for(new i = 0; i < strlen(string); i ++)
	{
	    if(strfind(string, "\n", true) != -1)
	    {
		    lastIndex = strfind(string, "\n", true);
		    strmid(string2, string, 0, lastIndex);
		    strdel(string, 0, lastIndex+1);
		    
		    format(string2, sizeof(string2), ""#C_RED"> "#C_WHITE"%s\n", string2);
            strcat(chString, string2);
		}
		else
		{
		    format(string, sizeof(string), ""C_RED"> "#C_WHITE"%s", string);
		    strcat(chString, string);
	 		break;
		}
	}
	return chString;
}

stock FootNote(message[])
{
	new text[128];
	strmid(text, message, 0, 128, 128);

    if(strfind(text, "*", false) == -1) return text;

	new string[50];
	new index = -1, indexNum = 0, index2 = 0;

 	for(new i = 0; i < strlen(text); i ++)
	{
	    if(text[i] == '*')
	    {
	        indexNum ++;
	        if(indexNum == 1)
			{
				index = i;
			}
	        if(indexNum == 2)
	        {
	            indexNum = 0;
	            format(string, sizeof(string), ""#C_ACT"");
                strins(text, string, index);
                index2 = i += 8;
                format(string, sizeof(string), ""#C_FADE1"");
                strins(text, string, index2+1);
	        }
	    }
	}
	return text;
}

stock CreateActorEx(skinid, Float:x, Float:y, Float:z, Float:angle, name[], type = 1, animlib[] = "", animName[] = "", ...)
{
	for(new actorid = 0; actorid < MAX_ACTOR; actorid ++)
	{
	    if(ActorInfo[actorid][aCreate] != 1)
	    {
	        new actor = CreateActor(skinid, x, y, z, angle);

		    ActorInfo[actorid][aCreate] 		= 1;
		    ActorInfo[actorid][aNumber] 		= actorid;
		    ActorInfo[actorid][aID] 			= actor;
		    ActorInfo[actorid][aSkinId] 		= skinid;
		    ActorInfo[actorid][aType] 			= type;
		    ActorInfo[actorid][aPosition][0]	= x;
			ActorInfo[actorid][aPosition][1] 	= y;
			ActorInfo[actorid][aPosition][2] 	= z;
		    ActorInfo[actorid][aAngle] 			= angle;
		    strmid(ActorInfo[actorid][aName], name, 0, 50, 50);
		    strmid(ActorInfo[actorid][aAnimlib], animlib, 0, 50, 50);
		    strmid(ActorInfo[actorid][aAnimName], animName, 0, 50, 50);

		    new lines = numargs();
		    new minusVal = 9;
		    
			if(lines-minusVal > MAX_ACTOR_DIALOGUE) return printf("ERROR : %d num actor excess max lines", actorid);

	        for(new i = minusVal; i < lines; i ++)
	        {
	            new str[128];
	            for(new l = 0; getarg(i, l) != 0; l ++)
				{
				    str[l] = getarg(i, l);
				}
                strmid(ActorDialogue[actorid][i-minusVal], str, 0, 128, 128);
	        }
		    
		    if(strlen(name))
		    {
				new text[128];
				format(text, sizeof(text), "%s", ActorInfo[actorid][aName]);

	            ActorInfo[actorid][aTextLabelID1] = Create3DTextLabel(text, COLOR_ACTOR, x, y, z+1.0, 10.0, 0);
			}
			break;
		}
		else if(actorid == MAX_ACTOR-1) print("엑터를 더이상 생성할 수 없습니다.");
	}
	return 1;
	// Actor도 MySQL Table하나 만들어서 관리하려고 했는데 많지도 않고 귀찮아서 사용 안 하기로 함.
}

stock IsGivePlayerDistance(Float:Distance, playerid, giveplayerid)
{
    new Float:gx, Float:gy, Float:gz;
    GetPlayerPos(giveplayerid, gx, gy, gz);
    if(IsPlayerInRangeOfPoint(playerid, Distance, gx, gy, gz)) return 1;
    return 0;
}

stock BuildTypeName(type)
{
	new text[10];
	if(type == 0) strmid(text, "입/퇴", 0, 10, 10);
	if(type == 1) strmid(text, "집", 0, 10, 10);
	if(type == 2) strmid(text, "사업장", 0, 10, 10);
	return text;
}

stock IntegerParseInt(Integer[])
{
	new str[5];
	format(str, sizeof(str), "%d", Integer);
	return strval(str);
}

stock EnterEvent(playerid)
{
    SetTimerEx("FadeIn", FADE_DELAY, false, "id",playerid,255);
    SetTimerEx("UnFreeze", 3000, false, "d", playerid);
}
//********************** 인벤토리 관련 **********************//
stock InventoryMode(playerid, bool:boolean)
{
	if(IsPlayerLogin(playerid) && PlayerInfo[playerid][pTutorial] == 3 && PlayerInfo[playerid][pFirstSpawn] == 2)
	{
		if(boolean == true)
		{
			if(PlayerInfo[playerid][pInventoryMode] == true)
			    InventoryMode(playerid, false);
			    
			TextDrawSetPreviewModel(InventoryTD[playerid][1], GetPlayerSkin(playerid));
			
			new iconindex = -1;
			InvenSelectSlot[playerid] = 0;
			switch(InvenSelectSlot[playerid])
		    {
		        case 0: iconindex = 2;
		        case 1: iconindex = 3;
		        case 2: iconindex = 4;
		        case 3: iconindex = 25;
		        case 4: iconindex = 26;
				default : SendErrorMessage(playerid, "모드에 오류가 있습니다. F8로 스크린샷을 찍은 후 관리자에게 문의해주세요.");
		    }
			TextDrawColor(InventoryTD[playerid][iconindex], COLOR_TDCLICK);
			
			PlayerInfo[playerid][pItemDisPlace][0] = -1;
			PlayerInfo[playerid][pItemDisPlace][1] = -1;
			
			PlayerItemUpdate(playerid);
		}
		else if(boolean == false)
		{
		    HidePlayerProgressBar(playerid, InventoryWeightBar[playerid]);
		    
		    PlayerInfo[playerid][pItemDisPlace][0] = -1;
			PlayerInfo[playerid][pItemDisPlace][1] = -1;
		    
		    TextDrawColor(InventoryTD[playerid][2], COLOR_ICONCOLOR);
		    TextDrawColor(InventoryTD[playerid][3], COLOR_ICONCOLOR);
		    TextDrawColor(InventoryTD[playerid][4], COLOR_ICONCOLOR);
		    TextDrawColor(InventoryTD[playerid][25], COLOR_ICONCOLOR);
		    TextDrawColor(InventoryTD[playerid][26], COLOR_ICONCOLOR);
		    for(new i = 0; i < MAX_INVENTORY; i ++)
			{
				TextDrawHideForPlayer(playerid, InventoryTD[playerid][i]);
			}
			CancelSelectTextDraw(playerid);
			PlayerInfo[playerid][pInventoryMode] = false;
		}
	}
}

stock PlayerItemUpdate(playerid)
{
    new index = -1;
	new str[10];
	for(new t = START_ITEM_NUM; t < END_ITEM_NUM; t ++)
	{
	    index = t-START_ITEM_NUM;
	    if(InvenItem[playerid][InvenSelectSlot[playerid]][index] > 0 && InvenItemNum[playerid][InvenSelectSlot[playerid]][index] > 0)
	    {
	        format(str, sizeof(str), "%d", InvenItemNum[playerid][InvenSelectSlot[playerid]][index]);
	        TextDrawSetString(InventoryTD[playerid][t], str);
	    }
	    else
		{
			TextDrawSetString(InventoryTD[playerid][t], " ");
		}
	}

	for(new i = START_INVEN; i < END_INVEN; i ++)
	{
		index = i-START_INVEN;
		if(InvenItem[playerid][InvenSelectSlot[playerid]][index] > 0 && InvenItemNum[playerid][InvenSelectSlot[playerid]][index] > 0)
	    {
	        for(new inven = 0; inven < sizeof(InventoryItemInfo); inven ++)
	        {
	            if(InventoryItemInfo[inven][inven_number] == InvenItem[playerid][InvenSelectSlot[playerid]][index])
	            {
			        TextDrawSetString(InventoryTD[playerid][i], InventoryItemInfo[inven][inven_txdname]);
			    }
			}
	    }
	    else
	    {
			TextDrawSetString(InventoryTD[playerid][i], InventoryItemInfo[0][inven_txdname]);
	    }
	}
	
    for(new i = 0; i < MAX_INVENTORY; i ++)
	{
		TextDrawShowForPlayer(playerid, InventoryTD[playerid][i]);
	}
	SelectTextDraw(playerid, COLOR_TDCLICK);
	
	ShowPlayerProgressBar(playerid, InventoryWeightBar[playerid]);
	//SetPlayerProgressBarValue(playerid, InventoryWeightBar[playerid], 17);
	new Float:itemnum = InventoryItemTotalNum(playerid, InvenSelectSlot[playerid]);
	
	format(str, sizeof(str), "%.1f/%dKG", itemnum, MAX_INVEN_ITEM);
    SetPlayerProgressBarValue(playerid, InventoryWeightBar[playerid], itemnum);
	TextDrawSetString(InventoryTD[playerid][27], str);
	
	PlayerInfo[playerid][pInventoryMode] = true;
}

stock PlayerItemAdd(playerid, itemid, number)
{
	if(itemid <= 0 || number <= 0) return -1; // PlayerItemAdd 에서 itemid와 number의 숫자를 알맞지 않게 기입한 경우 -1값 리턴
	
	new slot = GetItemSlot(itemid);
	if(slot != -1)
	{
		new Float:number2 = number;
        new Float:maxWeight = (GetItemWeight(itemid)*number2) + InventoryItemTotalNum(playerid, slot);
		if(maxWeight > MAX_INVEN_ITEM) return -3; // 인벤토리 최대 무게를 초과했을 때

		new index = -1;
		for(new i = 0; i < MAX_INVEN_ITEM; i ++)
		{
			if(InvenItem[playerid][slot][i] == itemid)
			{
			    index = i;
				break;
			}
		}
		if(index == -1)
		{
			for(new i = 0; i < MAX_INVEN_ITEM; i ++)
			{
			    if(InvenItem[playerid][slot][i] == 0 && InvenItemNum[playerid][slot][i] == 0)
			    {
			        index = i;
					break;
			    }
			}
		}
		if(index != -1)
		{
			InvenItem[playerid][slot][index] 	=  itemid;
	        InvenItemNum[playerid][slot][index] += number;
	        if(InvenItemNum[playerid][slot][index] <= 0)
	        {
	            InvenItem[playerid][slot][index] 	= 0;
	            InvenItemNum[playerid][slot][index] = 0;
	        }
	        if(PlayerInfo[playerid][pInventoryMode] == true)
	        {
	            PlayerItemUpdate(playerid);
	        }
	        return 1; // 정상적으로 아이템이 추가 됬을 때
		}
	}
	else return -2; // 알 수 없는 아이템번호를 사용한 경우 -2리턴
	return 0; // 비정상적으로 아이템이 추가되지 않았을 때
}

stock PlayerItemDelete(playerid, itemid, number)
{
    if(itemid <= 0 || number <= 0) return -1; // PlayerItemDelete 에서 itemid와 number의 숫자를 알맞지 않게 기입한 경우 -1값 리턴
    new slot = GetItemSlot(itemid);
	if(slot != -1)
	{
        new index = -1;
		for(new i = 0; i < MAX_INVEN_ITEM; i ++)
		{
			if(InvenItem[playerid][slot][i] == itemid)
			{
			    index = i;
				break;
			}
		}
		if(index != -1)
		{
			InvenItem[playerid][slot][index] 	= 	itemid;
	        InvenItemNum[playerid][slot][index] -= 	number;
	        if(InvenItemNum[playerid][slot][index] <= 0)
	        {
	            InvenItem[playerid][slot][index] 	= 0;
	            InvenItemNum[playerid][slot][index] = 0;
	        }
	        if(PlayerInfo[playerid][pInventoryMode] == true)
	        {
	            PlayerItemUpdate(playerid);
	        }
	        return 1; // 정상적으로 아이템이 제거 됬을 때
		}
	}
	else return -2; // 알 수 없는 아이템번호를 사용한 경우 -2리턴
    return 0; // 내가 소지하고 있지 않은 아이템을 삭제하려고 든경우
}

stock PlayerItemDrop(playerid, itemid, number)
{
    if(IsItemDrop(itemid))
    {
        new animindex = GetPlayerAnimationIndex(playerid);
        if(animindex == 1189 || animindex == 1275)
		{
	    	new result = PlayerItemDelete(playerid, itemid, number);
	        if(result == 1)
	        {
	            new slot = GetItemSlot(itemid);
	        
	            new objectid;
	            switch(slot)
	            {
	                case 0: objectid = BAG_INVEN_OBJECT;
	                case 3:
	                {
	                
	                }
	            }
	            new Float:aPos[3], Float:bPos[3], Float:angle;
	            GetPlayerPos(playerid, aPos[0], aPos[1], aPos[2]);
	            GetPlayerFacingAngle(playerid, angle);
				GetPlayerFrontPos(playerid, bPos[0], bPos[1], bPos[2], 0.5);
				
				
	            return 1;
	        }
	        return result;
		}
		else return -5;
    }
    return 0; // 드랍될 수 없는 아이템일 때
}

stock GetItemSlot(itemid)
{
    new slot = -1;
    for(new inven = 0; inven < sizeof(InventoryItemInfo); inven ++)
	{
	    if(InventoryItemInfo[inven][inven_number] == itemid && InventoryItemInfo[inven][inven_number] != -1)
	    {
	        slot = IntegerParseInt(InventoryItemInfo[inven][inven_slot]);
	    }
	}
	return slot;
}

stock GetItemName(itemid)
{
    new name[50];
    for(new inven = 0; inven < sizeof(InventoryItemInfo); inven ++)
	{
	    if(InventoryItemInfo[inven][inven_number] == itemid && InventoryItemInfo[inven][inven_number] != -1)
	    {
	        strmid(name, InventoryItemInfo[inven][inven_name], 0, 50, 50);
	    }
	}
	return name;
}

forward Float:GetItemWeight(itemid);
stock Float:GetItemWeight(itemid)
{
    new Float:weight = 0.0;
    for(new inven = 0; inven < sizeof(InventoryItemInfo); inven ++)
	{
	    if(InventoryItemInfo[inven][inven_number] == itemid && InventoryItemInfo[inven][inven_number] != -1)
	    {
	        weight += InventoryItemInfo[inven][inven_weight];
	        break;
	    }
	}
	return weight;
}

stock GetItemTxdName(itemid)
{
    new name[50];
    for(new inven = 0; inven < sizeof(InventoryItemInfo); inven ++)
	{
	    if(InventoryItemInfo[inven][inven_number] == itemid && InventoryItemInfo[inven][inven_number] != -1)
	    {
	        strmid(name, InventoryItemInfo[inven][inven_txdname], 0, 50, 50);
	    }
	}
	return name;
}

stock IsItemDrop(itemid)
{
    for(new inven = 0; inven < sizeof(InventoryItemInfo); inven ++)
	{
	    if(InventoryItemInfo[inven][inven_number] == itemid && InventoryItemInfo[inven][inven_number] != -1)
	    {
	        return InventoryItemInfo[inven][inven_isdrop];
	    }
	}
	return 0;
}

stock IsItemGive(itemid)
{
    for(new inven = 0; inven < sizeof(InventoryItemInfo); inven ++)
	{
	    if(InventoryItemInfo[inven][inven_number] == itemid && InventoryItemInfo[inven][inven_number] != -1)
	    {
	        return InventoryItemInfo[inven][inven_isgive];
	    }
	}
	return 0;
}

stock IsItemHaveState(playerid, itemid)
{
	new slot = GetItemSlot(itemid);
	
	for(new i = 0; i < MAX_INVEN_ITEM; i ++)
	{
		if(InvenItem[playerid][slot][i] == itemid && InvenItemNum[playerid][slot][i] > 0)
		    return 1;
	}
	/*
    for(new inven = 0; inven < sizeof(InventoryItemInfo); inven ++)
	{
	    if(InventoryItemInfo[inven][inven_number] == itemid && InventoryItemInfo[inven][inven_number] != -1)
	    {
	    
	    }
	}*/
	return 0;
}

stock IsItemHaveNum(playerid, itemid)
{
	new slot = GetItemSlot(itemid);

	for(new i = 0; i < MAX_INVEN_ITEM; i ++)
	{
		if(InvenItem[playerid][slot][i] == itemid && InvenItemNum[playerid][slot][i] > 0)
		    return InvenItemNum[playerid][slot][i];
	}
	return 0;
}

forward Float:InventoryItemTotalNum(playerid, slot);
stock Float:InventoryItemTotalNum(playerid, slot)
{
	new Float:total = 0.0;
	new Float:number = 0.0;
	for(new i = 0; i < MAX_INVEN_ITEM; i ++)
		if(InvenItem[playerid][slot][i] > 0 && InvenItemNum[playerid][slot][i] > 0)
		    for(new inven = 0; inven < sizeof(InventoryItemInfo); inven ++)
		        if(InvenItem[playerid][slot][i] == InventoryItemInfo[inven][inven_number])
		        {
		            number = InvenItemNum[playerid][slot][i];
                    total += InventoryItemInfo[inven][inven_weight] * number;
                }
	return total;
}
//********************** 인벤토리 관련 **********************//
//********************** 폰 관련 **********************//
stock PhoneMode(playerid, bool:boolean)
{
	if(IsPlayerLogin(playerid) || PlayerInfo[playerid][pTutorial] == 3)
	{
	    if(IsItemHaveState(playerid, 1) == 1)
	    {
			if(boolean == true)
			{
			    if(PlayerInfo[playerid][pPhoneTDChk] == true) return 0;

			    new year, month, day,
					hour, minute, second;

				getdate(year, month, day);
				gettime(hour, minute, second);

			    new str[50];
				format(str, sizeof(str), "%04.d.%02.d.%02.d",year, month, day);
				TextDrawSetString(PlayerPhoneTD[playerid][17], str); // 날짜

				format(str, sizeof(str), "time:%02.d:%02.d",hour, minute);
				TextDrawSetString(PlayerPhoneTD[playerid][16], str); // 시간

				format(str, sizeof(str), "%02.d:%02.d",hour, minute);
				TextDrawSetString(PlayerPhoneTD[playerid][18], str); // 시간 (bar)

			    for(new i = 0; i < MAX_PHONE_MENUTD; i ++)
			    {
					TextDrawShowForPlayer(playerid, PlayerPhoneTD[playerid][i]);
			    }
				SelectTextDraw(playerid, COLOR_CLK_PHONE);

                PlayerInfo[playerid][pPhoneSelChk] = true;
			    PlayerInfo[playerid][pPhoneTDChk] = true;
			}
			else if(boolean == false)
			{
                for(new i = 0; i < MAX_PHONE_TD; i ++)
			    {
					TextDrawHideForPlayer(playerid, PlayerPhoneTD[playerid][i]);
			    }
				PlayerInfo[playerid][pPhoneSelChk] = false;
				PlayerInfo[playerid][pPhoneTDChk] = false;
				
				PlayerInfo[playerid][pCCallPlayer] = -1;
				
				CancelSelectTextDraw(playerid);
			}
		}
		else return SendErrorMessage(playerid, MessageText[7]);
	}
	return 1;
}

stock PlayerCall(playerid, callnum)
{
	if(IsPlayerLogin(playerid))
	{
		if(IsItemHaveState(playerid, 1) == 1)
		{
		    if(PlayerInfo[playerid][pPhoneNumber] == callnum) { SendErrorMessage(playerid, "자기 자신한테는 전화를 걸 수 없습니다."); return 0; }
			if(PlayerInfo[playerid][pCallNum] == -1)
		    {
		        if(callnum == 777)
		        {
		            return 1;
		        }
		        else
		        {
			        for(new i = 0; i < MAX_PLAYERS; i ++)
			        {
			            if(IsPlayerLogin(i))
			            {
			                if(IsItemHaveState(i, 1) == 1 && PlayerInfo[i][pPhoneNumber] == callnum)
			                {
			                    if(PlayerInfo[i][pCallNum] != -1) { SendErrorMessage(playerid, "상대방은 이미 통화중입니다."); return 0; }
			                    if(PlayerInfo[i][pPhonePower] == 0) { SendErrorMessage(playerid, "상대방의 휴대전화의 전원이 꺼져있습니다."); return 0; }
			                    KillTimerEx(PlayerInfo[playerid][pCallConTimer]);
			                    Audio_StopEx(playerid, PlayerInfo[playerid][pMCallBGM]);
			                    new result = playerPhoneRings(i, playerid);
			                    if(result == 1)
			                    {
			                        PlayerInfo[playerid][pMCallBGM] = Audio_PlayStreamed(playerid, "http://cfile9.uf.tistory.com/media/2360CB3A587E554E057668", false, true, false);
			                    
				                    PlayerInfo[playerid][pCallNum] = callnum;
				                    PlayerInfo[playerid][pCallPlayer] = i;
				                    PlayerInfo[playerid][pCallTake] = 0;

									PlayerInfo[playerid][pCallConLevel] = 0;
				                    PlayerInfo[playerid][pCallConTimer] = SetTimerEx("CallConTimer", 1000, true, "d", playerid);
				                    
				                    OnPlayerCommandText(playerid, "/me 핸드폰으로 전화를 건다.");
				                    return 1;
								}
			                }
			            }
			            if(i == MAX_PLAYERS-1) SendErrorMessage(playerid, "없는 번호입니다.");
			        }
				}
		    }
		    else SendErrorMessage(playerid, MessageText[8]);
		}
	    else SendErrorMessage(playerid, MessageText[7]);
	}
	else SendErrorMessage(playerid, MessageText[0]);
	return 0;
}

stock playerPhoneRings(playerid, giveplayerid)
{
	if(IsPlayerLogin(playerid))
	{
		if(IsItemHaveState(playerid, 1) == 1)
		{
			if(PlayerInfo[playerid][pCallNum] == -1)
		    {
		        new hour, minute, second;

				gettime(hour, minute, second);
		    
		        PhoneMode(playerid, false);
		        PlayerInfo[playerid][pPhoneTDChk] = true;
		        
		        PlayerInfo[playerid][pCCallPlayer] = giveplayerid;
		        
		        TextDrawShowForPlayer(playerid, PlayerPhoneTD[playerid][36]);
		        
		        new str[30];
		        format(str, sizeof(str), "%02.d:%02.d",hour, minute);
				TextDrawSetString(PlayerPhoneTD[playerid][18], str); // 시간 (bar)
				TextDrawShowForPlayer(playerid, PlayerPhoneTD[playerid][18]);
				
				OnPlayerCommandText(playerid, "/st (의)핸드폰에서 전화 벨소리가 울린다.");
				// OnPlayerCommandText(playerid, "/so
				
		        PlayerInfo[playerid][pCCallBGM] = Audio_PlayStreamed(playerid, "http://cfile23.uf.tistory.com/media/2148A73C587E57671A9B97", false, true, false);
		        return 1;
		    }
		}
	}
	return 0;
}

stock AroundPlayerList(playerid, Float:distance, playerids[], &allPlayer = 0)
{
	for(new i = 0; i < MAX_PLAYERS; i ++)
	{
	    if(i == playerid) continue;
	    if(IsPlayerLogin(i) && PlayerInfo[playerid][pTutorial] == 3)
	    {
	    	if(IsGivePlayerDistance(distance, playerid, i))
	    	{
	    	    playerids[allPlayer] = i;
	    	    allPlayer ++;
	    	}
		}
	}
}

stock GetWeaponModeid(weaponid)
{
	new objectid = -1;
	switch(weaponid)
	{
		case 1:  objectid = 331;
		case 2:  objectid = 333;
		case 3:  objectid = 334;
		case 4:  objectid = 335;
		case 5:  objectid = 336;
		case 6:  objectid = 337;
		case 7:  objectid = 338;
		case 8:  objectid = 339;
		case 9:  objectid = 341;
		case 10: objectid = 321;
		case 11: objectid = 322;
		case 12: objectid = 323;
		//case 13: objectid = 318;
		case 14: objectid = 325;
		case 15: objectid = 326;
		case 16: objectid = 342;
		case 17: objectid = 343;
		case 18: objectid = 344;
		case 22: objectid = 346;
		case 23: objectid = 347;
		case 24: objectid = 348;
		case 25: objectid = 349;
		case 26: objectid = 351;
		case 27: objectid = 350;
		case 28: objectid = 352;
		case 29: objectid = 353;
		case 30: objectid = 355;
		case 31: objectid = 356;
		case 32: objectid = 372;
		case 33: objectid = 357;
		case 34: objectid = 358;
		case 35: objectid = 359;
		case 36: objectid = 360;
		case 37: objectid = 361;
		case 38: objectid = 362;
		case 39: objectid = 363;
		case 40: objectid = 364;
		case 41: objectid = 365;
		case 42: objectid = 366;
		case 43: objectid = 367;
		case 44: objectid = 368;
		case 45: objectid = 369;
		case 46: objectid = 370;
	}
	return objectid;
}

stock SetPlayerHealthEx(playerid, Float:health)
{
	PlayerInfo[playerid][pHealth] = health;
	if(PlayerInfo[playerid][pHealth] >= 100) PlayerInfo[playerid][pHealth] = 100.0;
	SetPlayerProgressBarValue(playerid, PlayerInfo[playerid][pHudBar][0], PlayerInfo[playerid][pHealth]);
}

stock GivePlayerHealthEx(playerid, Float:health)
{
	PlayerInfo[playerid][pHealth] += health;
	if(PlayerInfo[playerid][pHealth] >= 100) PlayerInfo[playerid][pHealth] = 100.0;
	SetPlayerProgressBarValue(playerid, PlayerInfo[playerid][pHudBar][0], PlayerInfo[playerid][pHealth]);
}

stock SetPlayerArmourEx(playerid, Float:armour)
{
	PlayerInfo[playerid][pArmour] = armour;
	if(PlayerInfo[playerid][pArmour] >= 100) PlayerInfo[playerid][pArmour] = 100.0;
	SetPlayerProgressBarValue(playerid, PlayerInfo[playerid][pHudBar][1], PlayerInfo[playerid][pArmour]);
}

stock GivePlayerArmourEx(playerid, Float:armour)
{
	PlayerInfo[playerid][pArmour] += armour;
	if(PlayerInfo[playerid][pArmour] >= 100) PlayerInfo[playerid][pArmour] = 100.0;
	SetPlayerProgressBarValue(playerid, PlayerInfo[playerid][pHudBar][1], PlayerInfo[playerid][pArmour]);
}

stock SetPlayerMoneyEx(playerid, Money)
{
    PlayerInfo[playerid][pMoney] = Money;
    new str[20];
	format(str, sizeof(str), "%08.d", PlayerInfo[playerid][pMoney]);
	TextDrawSetString(PlayerHUDTD[playerid][0], str);
}

stock GivePlayerMoneyEx(playerid, Money)
{
    PlayerInfo[playerid][pMoney] += Money;
    new str[20];
	format(str, sizeof(str), "%08.d", PlayerInfo[playerid][pMoney]);
	TextDrawSetString(PlayerHUDTD[playerid][0], str);
}

stock SetPlayerHungryEx(playerid, Float:hungry)
{
	PlayerInfo[playerid][pHungry] = hungry;
	if(PlayerInfo[playerid][pHungry] >= 100) PlayerInfo[playerid][pHungry] = 100.0;
	SetPlayerProgressBarValue(playerid, PlayerInfo[playerid][pHudBar][2], PlayerInfo[playerid][pHungry]);
}

stock GivePlayerHungryEx(playerid, Float:hungry)
{
	PlayerInfo[playerid][pHungry] += hungry;
	if(PlayerInfo[playerid][pHungry] >= 100) PlayerInfo[playerid][pHungry] = 100.0;
	SetPlayerProgressBarValue(playerid, PlayerInfo[playerid][pHudBar][2], PlayerInfo[playerid][pHungry]);
}

stock SetPlayerEnergyEx(playerid, Float:energy)
{
	PlayerInfo[playerid][pEnergy] = energy;
	if(PlayerInfo[playerid][pEnergy] >= 100) PlayerInfo[playerid][pEnergy] = 100.0;
	SetPlayerProgressBarValue(playerid, PlayerInfo[playerid][pHudBar][3], PlayerInfo[playerid][pEnergy]);
}

stock GivePlayerEnergyEx(playerid, Float:energy)
{
	PlayerInfo[playerid][pEnergy] += energy;
	if(PlayerInfo[playerid][pEnergy] >= 100) PlayerInfo[playerid][pEnergy] = 100.0;
	SetPlayerProgressBarValue(playerid, PlayerInfo[playerid][pHudBar][3], PlayerInfo[playerid][pEnergy]);
}

stock getPhoneNumber()
{
    new randomPNum, bool:back = true;
    new query[200];
    
	while(back == true)
	{
		randomPNum = randomEx(1000000, 9999999);
		format(query, sizeof(query), "SELECT pPhoneNumber FROM `%s` WHERE `pPhoneNumber` = '%d' LIMIT 1", MySQL_USER, randomPNum);
		new Cache:result = mysql_query(MySQL, query, true);
		if(cache_num_rows())
			{ cache_delete(result); back = true; }
		else
            { cache_delete(result);  break;}
	}
	return randomPNum;
}

stock getAccountNumber()
{
    new randomANum, bool:back = true;
    new query[200];

	while(back == true)
	{
		randomANum = randomEx(100000, 999999);
		format(query, sizeof(query), "SELECT pAccountNum FROM `%s` WHERE `pAccountNum` = '%d' LIMIT 1", MySQL_USER, randomANum);
		new Cache:result = mysql_query(MySQL, query, true);
		if(cache_num_rows())
			{ cache_delete(result); back = true; }
		else
            { cache_delete(result);  break;}
	}
	return randomANum;
}

stock randomEx(min, max)
{
    new rand = random(max-min)+min;
    return rand;
}

stock sendSMS(playerid, receiveNumber, message[])
{
    new year, month, day,
		hour, minute, second;

	getdate(year, month, day);
	gettime(hour, minute, second);
	
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));

	for(new i = 0; i < MAX_PLAYERS; i ++)
	{
	    if(IsPlayerLogin(i))
	    {
		    if(PlayerInfo[i][pPhoneNumber] == receiveNumber)
		    {
		        new gName[MAX_PLAYER_NAME];
		        GetPlayerName(i, gName, sizeof(gName));
		        for(new a = 0; a < MAX_SMS; a ++)
		        {
		            if(SMSReceive_CallNum[i][a] == -1)
		            {
                        SMSReceive_CallNum[i][a] = PlayerInfo[playerid][pPhoneNumber];
                        SMSReceive_HitChk[i][a] = 1;
                        SMSReceive_Index[i][a] = a;
						SMSReceive_Year[i][a] = year;
						SMSReceive_Month[i][a] = month;
						SMSReceive_Day[i][a] = day;
						SMSReceive_Hour[i][a] = hour;
						SMSReceive_Minute[i][a] = minute;
						strmid(SMSReceive_Content[i][a], message, 0, 128+1, 128+1);
						break;
		            }
		            else if(a == MAX_SMS-1)
		            {
		                for(new c = 0; c < MAX_SMS; c ++)
		                {
		                    if(c == MAX_SMS-1)
		                    {
		                        SMSReceive_CallNum[i][c] = PlayerInfo[playerid][pPhoneNumber];
		                        SMSReceive_HitChk[i][c] = 1;
		                        SMSReceive_Index[i][c] = c;
								SMSReceive_Year[i][c] = year;
								SMSReceive_Month[i][c] = month;
								SMSReceive_Day[i][c] = day;
								SMSReceive_Hour[i][c] = hour;
								SMSReceive_Minute[i][c] = minute;
								strmid(SMSReceive_Content[i][c], message, 0, 128+1, 128+1);
		                    }
		                    else
		                    {
		                    	SMSReceive_CallNum[i][c] = SMSReceive_CallNum[i][c+1];
		                    	SMSReceive_HitChk[i][c] = SMSReceive_HitChk[i][c+1];
		                    	SMSReceive_Index[i][c] = SMSReceive_Index[i][c+1];
								SMSReceive_Year[i][c] = SMSReceive_Year[i][c+1];
								SMSReceive_Month[i][c] = SMSReceive_Month[i][c+1];
								SMSReceive_Day[i][c] = SMSReceive_Day[i][c+1];
								SMSReceive_Hour[i][c] = SMSReceive_Hour[i][c+1];
								SMSReceive_Minute[i][c] = SMSReceive_Minute[i][c+1];
								strmid(SMSReceive_Content[i][c], SMSReceive_Content[i][c+1], 0, 128+1, 128+1);
							}
		                }
		            }
		        }
		        for(new s = 0; s < MAX_SMS; s ++)
		        {
		        	if(SMSSend_CallNum[playerid][s] == -1)
		        	{
		        	    SMSSend_CallNum[playerid][s] = receiveNumber;
		        	    SMSSend_Index[playerid][s] = s;
						SMSSend_Year[playerid][s] = year;
						SMSSend_Month[playerid][s] = month;
						SMSSend_Day[playerid][s] = day;
						SMSSend_Hour[playerid][s] = hour;
						SMSSend_Minute[playerid][s] = minute;
						strmid(SMSSend_Content[playerid][s], message, 0, 128+1, 128+1);
						break;
		        	}
		        	else if(s == MAX_SMS-1)
		        	{
		        	    for(new z = 0; z < MAX_SMS; z ++)
		                {
		                    if(z == MAX_SMS-1)
		                    {
		                        SMSSend_CallNum[playerid][z] = receiveNumber;
		                        SMSSend_Index[playerid][z] = z;
								SMSSend_Year[playerid][z] = year;
								SMSSend_Month[playerid][z] = month;
								SMSSend_Day[playerid][z] = day;
								SMSSend_Hour[playerid][z] = hour;
								SMSSend_Minute[playerid][z] = minute;
								strmid(SMSSend_Content[playerid][z], message, 0, 128+1, 128+1);
		                    }
		                    else
		                    {
		                        SMSSend_CallNum[playerid][z] = SMSSend_CallNum[playerid][z+1];
		                        SMSSend_Index[playerid][z] = SMSSend_Index[playerid][z+1];
								SMSSend_Year[playerid][z] = SMSSend_Year[playerid][z+1];
								SMSSend_Month[playerid][z] = SMSSend_Month[playerid][z+1];
								SMSSend_Day[playerid][z] = SMSSend_Day[playerid][z+1];
								SMSSend_Hour[playerid][z] = SMSSend_Hour[playerid][z+1];
								SMSSend_Minute[playerid][z] = SMSSend_Minute[playerid][z+1];
								strmid(SMSSend_Content[playerid][z], SMSSend_Content[playerid][z+1], 0, 128+1, 128+1);
							}
		                }
		        	}
				}
				SendMessage(i, "새 메세지가 도착하였습니다.");
				OnPlayerSave(i, 2);
				OnPlayerSave(playerid, 2);
		        return 1;
		    }
		}
	}

	new query[512];
    format(query, sizeof(query), "SELECT * FROM `%s` WHERE `SMSPhoneNumber` = '%d' LIMIT 1", MySQL_SMS, receiveNumber);
	new Cache:result = mysql_query(MySQL, query, true);
	
	new sms_rec_temp_call[MAX_SMS], sms_rec_temp_hit[MAX_SMS], sms_rec_temp_year[MAX_SMS],
    	sms_rec_temp_month[MAX_SMS], sms_rec_temp_day[MAX_SMS], sms_rec_temp_hour[MAX_SMS],
    	sms_rec_temp_minute[MAX_SMS], sms_rec_temp_cont[MAX_SMS][128], sms_rec_temp_Index[MAX_SMS], tempSecond;

	if(cache_num_rows())
	{
	    new string[50], temp[50];
		for(new r = 0; r < MAX_SMS; r ++)
		{
	        format(string, sizeof(string), "SMSReceive_Index_%d", r); cache_get_value_name_int(0, string, sms_rec_temp_Index[r]);
	        format(string, sizeof(string), "SMSReceive_CallNum_%d",r); cache_get_value_name_int(0, string, sms_rec_temp_call[r]);
	        format(string, sizeof(string), "SMSReceive_HitChk_%d",r); cache_get_value_name_int(0, string, sms_rec_temp_hit[r]);
	        format(string, sizeof(string), "SMSReceive_Date_%d",r); cache_get_value_name(0, string, temp);
	        DateDecryption(temp, sms_rec_temp_year[r], sms_rec_temp_month[r], sms_rec_temp_day[r], sms_rec_temp_hour[r], sms_rec_temp_minute[r], tempSecond);
	        format(string, sizeof(string), "SMSReceive_Content_%d",r); cache_get_value_name(0, string, sms_rec_temp_cont[r]);
		}
		for(new i = 0; i < MAX_SMS; i ++)
		{
			if(sms_rec_temp_call[i] == -1)
			{
			    format(query, sizeof(query), "UPDATE `%s` SET", MySQL_SMS);
			    format(query, sizeof(query), "%s `SMSReceive_CallNum_%d` = '%d',", query, i, PlayerInfo[playerid][pPhoneNumber]);
			    format(query, sizeof(query), "%s `SMSReceive_HitChk_%d` = '%d',", query, i, 1);
			    format(query, sizeof(query), "%s `SMSReceive_Index_%d` = '%d',", query, i, i);
			    format(query, sizeof(query), "%s `SMSReceive_Date_%d` = '%s',", query, i, DateInsert(year, month, day, hour, minute, -1));
			    format(query, sizeof(query), "%s `SMSReceive_Content_%d` = '%s'", query, i, message);
			    format(query, sizeof(query), "%s WHERE `SMSPhoneNumber` = '%d' LIMIT 1", query, receiveNumber);
       			mysql_tquery(MySQL, query, "", "");
			    break;
			}
			else if(i == MAX_SMS-1)
			{
			    for(new c = 0; c < MAX_SMS; c ++)
	            {
	                if(c == MAX_SMS-1)
	                {
	                    sms_rec_temp_call[c] = PlayerInfo[playerid][pPhoneNumber];
	                    sms_rec_temp_hit[c] = 1;
						sms_rec_temp_year[c] = year;
						sms_rec_temp_month[c] = month;
						sms_rec_temp_day[c] = day;
						sms_rec_temp_Index[c] = c;
						sms_rec_temp_hour[c] = hour;
						sms_rec_temp_minute[c]= minute;
						strmid(sms_rec_temp_cont[c], message, 0, 128+1, 128+1);
	                }
	                else
	                {
	                    sms_rec_temp_call[c] = sms_rec_temp_call[c+1];
	                    sms_rec_temp_hit[c] = sms_rec_temp_hit[c+1];
						sms_rec_temp_year[c] = sms_rec_temp_year[c+1];
						sms_rec_temp_month[c] = sms_rec_temp_month[c+1];
						sms_rec_temp_Index[c] = sms_rec_temp_Index[c+1];
						sms_rec_temp_day[c] = sms_rec_temp_day[c+1];
						sms_rec_temp_hour[c] = sms_rec_temp_hour[c+1];
						sms_rec_temp_minute[c] = sms_rec_temp_minute[c+1];
						strmid(sms_rec_temp_cont[c], sms_rec_temp_cont[c+1], 0, 128+1, 128+1);
					}
					format(query, sizeof(query), "UPDATE `%s` SET", MySQL_SMS);
				    format(query, sizeof(query), "%s `SMSReceive_CallNum_%d` = '%d',", query, c, sms_rec_temp_call[c]);
				    format(query, sizeof(query), "%s `SMSReceive_HitChk_%d` = '%d',", query, c, sms_rec_temp_hit[c]);
				    format(query, sizeof(query), "%s `SMSReceive_Index_%d` = '%d',", query, c, sms_rec_temp_Index[c]);
				    format(query, sizeof(query), "%s `SMSReceive_Date_%d` = '%s',", query, c, DateInsert(sms_rec_temp_year[c], sms_rec_temp_month[c], sms_rec_temp_day[c], sms_rec_temp_hour[c], sms_rec_temp_minute[c], -1));
				    format(query, sizeof(query), "%s `SMSReceive_Content_%d` = '%s'", query, c, sms_rec_temp_cont[c]);
				    format(query, sizeof(query), "%s WHERE `SMSPhoneNumber` = '%d' LIMIT 1", query, receiveNumber);
				    mysql_tquery(MySQL, query, "", "");
	            }
			}
		}
		for(new s = 0; s < MAX_SMS; s ++)
		{
			if(SMSSend_CallNum[playerid][s] == -1)
			{
			    SMSSend_CallNum[playerid][s] = receiveNumber;
				SMSSend_Year[playerid][s] = year;
				SMSSend_Month[playerid][s] = month;
				SMSSend_Index[playerid][s] = s;
				SMSReceive_Index[playerid][s] = s;
				SMSSend_Day[playerid][s] = day;
				SMSSend_Hour[playerid][s] = hour;
				SMSSend_Minute[playerid][s] = minute;
				strmid(SMSSend_Content[playerid][s], message, 0, 128+1, 128+1);
				break;
			}
			else if(s == MAX_SMS-1)
			{
			    for(new z = 0; z < MAX_SMS; z ++)
		        {
		            if(z == MAX_SMS-1)
		            {
		                SMSSend_CallNum[playerid][z] = receiveNumber;
		                SMSSend_Index[playerid][z] = z;
						SMSSend_Year[playerid][z] = year;
						SMSSend_Month[playerid][z] = month;
						SMSSend_Day[playerid][z] = day;
						SMSSend_Hour[playerid][z] = hour;
						SMSSend_Minute[playerid][z] = minute;
						strmid(SMSSend_Content[playerid][z], message, 0, 128+1, 128+1);
		            }
		            else
		            {
		                SMSSend_CallNum[playerid][z] = SMSSend_CallNum[playerid][z+1];
		                SMSSend_Index[playerid][z] = SMSSend_Index[playerid][z+1];
						SMSSend_Year[playerid][z] = SMSSend_Year[playerid][z+1];
						SMSSend_Month[playerid][z] = SMSSend_Month[playerid][z+1];
						SMSSend_Day[playerid][z] = SMSSend_Day[playerid][z+1];
						SMSSend_Hour[playerid][z] = SMSSend_Hour[playerid][z+1];
						SMSSend_Minute[playerid][z] = SMSSend_Minute[playerid][z+1];
						strmid(SMSSend_Content[playerid][z], SMSSend_Content[playerid][z+1], 0, 128+1, 128+1);
					}
		        }
			}
		}
		OnPlayerSave(playerid, 2);
		cache_delete(result);
		return 1;
	}
	cache_delete(result);
	return 0;
}

stock playerRemittance(playerid, accountNum, money)
{
	if(PlayerInfo[playerid][pAccountMoney] >= money)
	{
		if(100000 <= accountNum <= 999999)
		{
			for(new i = 0; i < MAX_PLAYERS; i ++)
			{
			    if(IsPlayerLogin(i))
			    {
			        if(PlayerInfo[i][pAccountNum] == accountNum)
			        {
			            if(IsItemHaveState(i, 2004) == 1)
			            {
			                PlayerInfo[playerid][pAccountMoney] -= money;
			                PlayerInfo[i][pAccountMoney] += money;
			                return 1;
			            }
						return 0;
			        }
			    }
			}
            new query[150];
		    format(query, sizeof(query), "SELECT * FROM `%s` WHERE `pAccountNum` = '%d' LIMIT 1", MySQL_USER, accountNum);
			new Cache:result = mysql_query(MySQL, query, true);
			
			if(cache_num_rows())
			{
			    new slot = GetItemSlot(2004), inven_item;
			    new string[50];
			    
			    for(new i = 0; i < MAX_INVEN_ITEM; i ++)
				{
					format(string, sizeof(string), "InvenItem%d_%d", slot, i); cache_get_value_name_int(0, string, inven_item);
					if(inven_item == 2004)
					{
					    cache_delete(result);
					    
					    PlayerInfo[playerid][pAccountMoney] -= money;
					    
					    format(query, sizeof(query), "UPDATE `%s` SET", MySQL_USER);
					    format(query, sizeof(query), "%s `pAccountMoney` = pAccountMoney + %d", query, money);
					    format(query, sizeof(query), "%s WHERE `pAccountNum` = '%d' LIMIT 1", query, accountNum);
					    mysql_query(MySQL, query, false);
						return 1;
					}
				}
				cache_delete(result);
			    return 0;
			}
		}
		return 0;
	}
	return -1;
}

stock ConvertLineTwoString(playerid, text[], color1, color2, color3, color4, color5, player = 0)
{
    new string[3][256];
    strmid(string[2], text, 0, 128, 128);
    if(strlen(text) < 128)
	{
		SendAroundMessage(playerid, 10.0, color1, color2, color3, color4, color5, string[2], player);
	}
	else
	{
	    new length = 0;
		for(new i = 0; i < strlen(text); i ++)
		{
	 		if((text[i] & 0x80) == 0x80)
	 		{
	 		    if(i == 125 || i == 126)
	 		    {
		 		    strmid(string[0], text, 0, i+1, i+1);
		 		    SendAroundMessage(playerid, 10.0, color1, color2, color3, color4, color5, string[0], player);
		 		    length = i;
		 		    break;
				}
				i ++;
	 		}
		}
	    strmid(string[1], text, length, 256, 256);
	    SendAroundMessage(playerid, 10.0, color1, color2, color3, color4, color5, string[1], player);
	}
}

stock string_cut(text[], size)
{
	new string[128];
	strmid(string, text, 0, 128, 128);
	if(strlen(string) < size) return string;
	new length = strlen(string);
	for(new i = 0; i < length; i ++)
	{
	    if((string[i] & 0x80) == 0x80)
 		{
 		    if(i == size-2 || i == size-1)
 		    {
 		        strmid(string, string, 0, i+1, i+1);
 		        break;
 		    }
 		    i ++;
 		}
		else if(i == length -1)
		{
		    strmid(string, string, 0, size, size);
		}
	}
	return string;
}

stock string_nextLine(text[])
{
	new length = 0;
	new string[3][150];
	
	format(string[2], 128, "%s", text);
	if(strlen(string[2]) < 64) return string[2];
	
	for(new i = 0; i < strlen(text); i ++)
	{
 		if((text[i] & 0x80) == 0x80)
 		{
 		    if(i == 61 || i == 62)
 		    {
	 		    strmid(string[0], text, 0, i+1, i+1);
	 		    length = i;
	 		    break;
			}
			i ++;
 		}
	}
	if(length != 0)
	{
	    strmid(string[1], text, length, 150, 150);
	    format(string[2], 150, "%s\n%s", string[0], string[1]);
	}
	else
	{
	    strmid(string[0], text, 0, 64, 64);
	    strmid(string[1], text, 63, 128, 128);
	    format(string[2], 150, "%s\n%s", string[0], string[1]);
	}
	return string[2];
}

stock KillTimerEx(&var)
{
	if(var != -1)
	{
	    KillTimer(var);
	    var = -1;
	    return 1;
	}
	return 0;
}

stock Audio_StopEx(playerid, &var)
{
	if(var != -1)
	{
	    Audio_Stop(playerid, var);
	    var = -1;
	    return 1;
	}
	return 0;
}

stock DeleteDynamicObjectEx(&var)
{
	if(var != -1)
	{
	    DestroyDynamicObject(var);
	    var = -1;
	}
}

stock privateNoteDatabaseGenerate(playerid, text[])
{
    for(new i = 0; i < MAX_NOTE; i ++)
	{
	    if(privateNote_Create[playerid][i] == 0)
	    {
	        new name[MAX_PLAYER_NAME];
			GetPlayerName(playerid, name, sizeof(name));
	    
	        new year, month, day,
			hour, minute, second;

			getdate(year, month, day);
			gettime(hour, minute, second);
			
			privateNote_Create[playerid][i] = 1;
			privateNote_Date[playerid][i][0] = year; privateNote_Date[playerid][i][1] = month; privateNote_Date[playerid][i][2] = day;
			privateNote_Time[playerid][i][0] = hour; privateNote_Time[playerid][i][1] = minute; privateNote_Index[playerid][i] = i;
			strmid(privateNote_Name[playerid][i], name, 0, MAX_PLAYER_NAME+1, MAX_PLAYER_NAME+1);
	        strmid(privateNote_Content[playerid][i], text, 0, 128+1, 128+1);
	        
	        new string[200];
			format(string, 200, "INSERT INTO `%s` (`privateNote_Name`, `privateNote_Index`) VALUES ('%s', '%d')", MySQL_NOTE, name, privateNote_Index[playerid][i]);
			mysql_query(MySQL, string, false);
			
			OnPlayerSave(playerid, 3, i);
			return 1;
	    }
	}
	return 0;
}

stock privateNoteDatabaseLoad(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));

    new query[250];
	mysql_format(MySQL, query, sizeof(query), "SELECT * FROM `%s` WHERE `privateNote_Name` = '%s' ORDER BY `privateNote_Index` ASC LIMIT %d", MySQL_NOTE, name, MAX_NOTE);
    mysql_query(MySQL, query, true);
	new rows = cache_num_rows();
	
	if(!rows) return 0;
	
	new temp[50], string[50], tempSecond;
	for(new r = 0; r < rows; r ++)
	{

	    format(string, sizeof(string), "privateNote_Create", r); cache_get_value_name_int(r, string, privateNote_Create[playerid][r]);
	    format(string, sizeof(string), "privateNote_Date", r); cache_get_value_name(r, string, temp);
	    DateDecryption(temp, privateNote_Date[playerid][r][0], privateNote_Date[playerid][r][1], privateNote_Date[playerid][r][2], privateNote_Time[playerid][r][0], privateNote_Time[playerid][r][1], tempSecond);
	    format(string, sizeof(string), "privateNote_Index", r); cache_get_value_name_int(r, string, privateNote_Index[playerid][r]);
	    format(string, sizeof(string), "privateNote_Name", r); cache_get_value_name(r, string, privateNote_Name[playerid][r]);
	    format(string, sizeof(string), "privateNote_Content", r); cache_get_value_name(r, string, privateNote_Content[playerid][r]);
	}
    return 1;
}

stock privateNoteDatabaseDelete(playerid, index)
{
	if(privateNote_Create[playerid][index] == 1)
	{
	    new name[MAX_PLAYER_NAME];
		GetPlayerName(playerid, name, sizeof(name));
	
	    for(new i = index; i < MAX_NOTE; i ++)
	    {
	        if(privateNote_Create[playerid][i+1] == 1)
	        {
			    privateNote_Create[playerid][i] = privateNote_Create[playerid][i+1];
				privateNote_Date[playerid][i][0] = privateNote_Date[playerid][i+1][0];
				privateNote_Date[playerid][i][1] = privateNote_Date[playerid][i+1][1];
				privateNote_Date[playerid][i][2] = privateNote_Date[playerid][i+1][2];
				privateNote_Time[playerid][i][0] = privateNote_Time[playerid][i+1][0];
				privateNote_Time[playerid][i][1] = privateNote_Time[playerid][i+1][1];
				//privateNote_Index[playerid][i] = privateNote_Index[playerid][i+1]-1;
				strmid(privateNote_Name[playerid][i], privateNote_Name[playerid][i+1], 0, MAX_PLAYER_NAME+1, MAX_PLAYER_NAME+1);
			    strmid(privateNote_Content[playerid][i], privateNote_Content[playerid][i+1], 0, 128+1, 128+1);
		    }
		    else
		    {
		        new string[200];
				format(string, 200, "DELETE FROM `%s` WHERE `privateNote_Name` =  '%s' AND `privateNote_Index` = '%d' LIMIT 1", MySQL_NOTE, name, privateNote_Index[playerid][i]);
				mysql_query(MySQL, string, false);
				
				privateNote_Create[playerid][i] = 0;
				privateNote_Date[playerid][i][0] = 0;
				privateNote_Date[playerid][i][1] = 0;
				privateNote_Date[playerid][i][2] = 0;
				privateNote_Time[playerid][i][0] = 0;
				privateNote_Time[playerid][i][1] = 0;
				privateNote_Index[playerid][i] = -1;
				strmid(privateNote_Name[playerid][i], "", 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
			    strmid(privateNote_Content[playerid][i], "", 0, 128, 128);
		        break;
		    }
		}
		OnPlayerSave(playerid, 3);
	    return 1;
	}
    return 0;
}

stock smsDatabaseGenerate(playerid)
{
    PlayerItemAdd(playerid, 1, 1);
    PlayerInfo[playerid][pPhoneNumber] = getPhoneNumber();

    new string[750];
	format(string, 200, "INSERT INTO `%s` (`SMSPhoneNumber`) VALUES ('%d')", MySQL_SMS, PlayerInfo[playerid][pPhoneNumber]);
	mysql_query(MySQL, string, false);

	// OnPlayerSave(playerid, 2);
	for(new i = 0; i < MAX_SMS; i ++)
	{
	    format(string, sizeof(string), "UPDATE `%s` SET", MySQL_SMS);
	    format(string, sizeof(string), "%s `SMSSend_CallNum_%d` = '%d',",string, i, SMSSend_CallNum[playerid][i]);
		format(string, sizeof(string), "%s `SMSSend_Index_%d` = '%d',",string, i, SMSSend_Index[playerid][i]);
		format(string, sizeof(string), "%s `SMSSend_Date_%d` = '%s',",string, i, DateInsert(SMSSend_Year[playerid][i], SMSSend_Month[playerid][i], SMSSend_Day[playerid][i], SMSSend_Hour[playerid][i], SMSSend_Minute[playerid][i], -1));
	    format(string, sizeof(string), "%s `SMSSend_Content_%d` = '%s',",string, i, SMSSend_Content[playerid][i]);

	    format(string, sizeof(string), "%s `SMSReceive_CallNum_%d` = '%d',",string, i, SMSReceive_CallNum[playerid][i]);
	    format(string, sizeof(string), "%s `SMSReceive_HitChk_%d` = '%d',",string, i, SMSReceive_HitChk[playerid][i]);
		format(string, sizeof(string), "%s `SMSReceive_Index_%d` = '%d',",string, i, SMSReceive_Index[playerid][i]);
        format(string, sizeof(string), "%s `SMSReceive_Date_%d` = '%s',",string, i, DateInsert(SMSReceive_Year[playerid][i], SMSReceive_Month[playerid][i], SMSReceive_Day[playerid][i], SMSReceive_Hour[playerid][i], SMSReceive_Minute[playerid][i], -1));
	    format(string, sizeof(string), "%s `SMSReceive_Content_%d` = '%s'",string, i, SMSReceive_Content[playerid][i]);
	    mysql_format(MySQL, string, sizeof(string), "%s WHERE `SMSPhoneNumber` = '%d'", string, PlayerInfo[playerid][pPhoneNumber]);
	    mysql_query(MySQL, string, false);
	}
}

stock smsDatabaseLoad(playerid)
{
    new query[200];
	format(query, sizeof(query), "SELECT * FROM `%s` WHERE `SMSPhoneNumber` = '%d' LIMIT 1", MySQL_SMS, PlayerInfo[playerid][pPhoneNumber]);
	new Cache:result = mysql_query(MySQL, query, true);
	
	if(cache_num_rows())
	{
	    new string[50], temp[50], tempSecond;
	    for(new r = 0; r < MAX_SMS; r ++)
	    {
		    format(string, sizeof(string), "SMSReceive_Index_%d", r); cache_get_value_name_int(0, string, SMSReceive_Index[playerid][r]);
	        format(string, sizeof(string), "SMSReceive_CallNum_%d",r); cache_get_value_name_int(0, string, SMSReceive_CallNum[playerid][r]);
	        format(string, sizeof(string), "SMSReceive_HitChk_%d",r); cache_get_value_name_int(0, string, SMSReceive_HitChk[playerid][r]);
	        format(string, sizeof(string), "SMSReceive_Date_%d",r); cache_get_value_name(0, string, temp);
	        DateDecryption(temp, SMSReceive_Year[playerid][r], SMSReceive_Month[playerid][r], SMSReceive_Day[playerid][r], SMSReceive_Hour[playerid][r], SMSReceive_Minute[playerid][r], tempSecond);
	        format(string, sizeof(string), "SMSReceive_Content_%d",r); cache_get_value_name(0, string, SMSReceive_Content[playerid][r]);

	        format(string, sizeof(string), "SMSSend_CallNum_%d", r); cache_get_value_name_int(0, string, SMSSend_CallNum[playerid][r]);
	        format(string, sizeof(string), "SMSSend_Index_%d",r); cache_get_value_name_int(0, string, SMSSend_Index[playerid][r]);
	        format(string, sizeof(string), "SMSSend_Date_%d",r); cache_get_value_name(0, string, temp);
	        DateDecryption(temp, SMSSend_Year[playerid][r], SMSSend_Month[playerid][r], SMSSend_Day[playerid][r], SMSSend_Hour[playerid][r], SMSSend_Minute[playerid][r], tempSecond);
		    format(string, sizeof(string), "SMSSend_Content_%d",r); cache_get_value_name(0, string, SMSSend_Content[playerid][r]);
		}
	}
	cache_delete(result);
}

stock numNoteDatabaseGenerate(playerid, number)
{
    for(new i = 0; i < MAX_NUM_NOTE; i ++)
    {
		if(NumberNote_Create[playerid][i] == 0)
		{
		    new query[200], gName[MAX_PLAYER_NAME];
		    
			format(query, sizeof(query), "SELECT `pName` FROM `%s` WHERE `pPhoneNumber` = '%d' LIMIT 1", MySQL_USER, number);
			new Cache:result = mysql_query(MySQL, query, true);
			if(cache_num_rows())
			{
		    	cache_get_value_name(0, "pName", gName);
		    	cache_delete(result);
		    }
		    else
		    {
		        cache_delete(result);
		        return -1;
		    }
			format(query, sizeof(query), "INSERT INTO `%s` (`NumberNote_Name`, `NumberNote_Index`) VALUES ('%s', '%d')", MySQL_NUM_NOTE, PlayerNameEx(playerid), i);
			mysql_query(MySQL, query, false);
			
			NumberNote_Create[playerid][i] = 1;
			NumberNote_CallNum[playerid][i] = number;
			NumberNote_Index[playerid][i] = i;
			strmid(NumberNote_Name[playerid][i], PlayerNameEx(playerid), 0, MAX_PLAYER_NAME+1, MAX_PLAYER_NAME+1);
			strmid(NumberNote_NickName[playerid][i], gName, 0, MAX_PLAYER_NAME+1, MAX_PLAYER_NAME+1);
			
			OnPlayerSave(playerid, 4, i);
			return 1;
	    }
	}
	return 0;
}

stock numNoteDatabaseLoad(playerid)
{
    new query[200];
	mysql_format(MySQL, query, sizeof(query), "SELECT * FROM `%s` WHERE `NumberNote_Name` = '%s' ORDER BY `NumberNote_Index` ASC LIMIT %d", MySQL_NUM_NOTE, PlayerNameEx(playerid), MAX_NOTE);
	new Cache:result = mysql_query(MySQL, query, true);
	new rows = cache_num_rows();
	
	for(new r = 0; r < rows; r ++)
	{
	    new string[50];
	    format(string, sizeof(string), "NumberNote_Create", r); cache_get_value_name_int(r, string, NumberNote_Create[playerid][r]);
        format(string, sizeof(string), "NumberNote_Name",r); cache_get_value_name(r, string, NumberNote_Name[playerid][r]);
        format(string, sizeof(string), "NumberNote_Index",r); cache_get_value_name_int(r, string, NumberNote_Index[playerid][r]);
        format(string, sizeof(string), "NumberNote_CallNum",r); cache_get_value_name_int(r, string, NumberNote_CallNum[playerid][r]);
        format(string, sizeof(string), "NumberNote_NickName",r); cache_get_value_name(r, string, NumberNote_NickName[playerid][r]);
	}
	cache_delete(result);
}

stock numNoteDatabaseDelete(playerid, index)
{
    if(NumberNote_Create[playerid][index] == 1)
	{
	    for(new i = index; i < MAX_NOTE; i ++)
	    {
	        if(NumberNote_Create[playerid][i+1] == 1)
	        {
			    NumberNote_Create[playerid][i] = NumberNote_Create[playerid][i+1];
				//NumberNote_Index[playerid][i] = NumberNote_Index[playerid][i+1];
				NumberNote_CallNum[playerid][i] = NumberNote_CallNum[playerid][i+1];
				strmid(NumberNote_NickName[playerid][i], NumberNote_NickName[playerid][i+1], 0, MAX_PLAYER_NAME+1, MAX_PLAYER_NAME+1);
			    strmid(NumberNote_Name[playerid][i], NumberNote_Name[playerid][i+1], 0, MAX_PLAYER_NAME+1, MAX_PLAYER_NAME+1);
		    }
		    else
		    {
		        new string[200];
				format(string, 200, "DELETE FROM `%s` WHERE `NumberNote_Name` = '%s' AND `NumberNote_Index` = '%d' LIMIT 1", MySQL_NUM_NOTE, PlayerNameEx(playerid), NumberNote_Index[playerid][i]);
				mysql_query(MySQL, string, false);

				NumberNote_Create[playerid][i] = 0;
				NumberNote_Index[playerid][i] = -1;
				NumberNote_CallNum[playerid][i] = 0;
				strmid(NumberNote_NickName[playerid][i], "", 0, MAX_PLAYER_NAME+1, MAX_PLAYER_NAME+1);
			    strmid(NumberNote_Name[playerid][i], "", 0, MAX_PLAYER_NAME+1, MAX_PLAYER_NAME+1);
		        break;
		    }
		}
		OnPlayerSave(playerid, 4);
	    return 1;
	}
    return 0;
}

stock mp3DatabaseGenerate(playerid, title[], url[])
{
    for(new i = 0; i < MAX_MP3; i ++)
    {
		if(playerMP3_Create[playerid][i] == 0)
		{
		    new query[200];
		    
            format(query, sizeof(query), "INSERT INTO `%s` (`playerMP3_Name`, `playerMP3_Index`) VALUES ('%s', '%d')", MySQL_MP3, PlayerNameEx(playerid), i);
			mysql_query(MySQL, query, false);
			
			playerMP3_Create[playerid][i] = 1;
			playerMP3_Index[playerid][i] = i;
			strmid(playerMP3_Name[playerid][i], PlayerNameEx(playerid), 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
			strmid(playerMP3_Url[playerid][i], url, 0, 128, 128);
		    strmid(playerMP3_Title[playerid][i], title, 0, 50, 50);
			
			OnPlayerSave(playerid, 5, i);
			return 1;
	    }
	}
	return 0;
}

stock mp3DatabaseLoad(playerid)
{
    new query[200];
	mysql_format(MySQL, query, sizeof(query), "SELECT * FROM `%s` WHERE `playerMP3_Name` = '%s' ORDER BY `playerMP3_Index` ASC LIMIT %d", MySQL_MP3, PlayerNameEx(playerid), MAX_MP3);
	new Cache:result = mysql_query(MySQL, query, true);
	new rows = cache_num_rows();

	for(new r = 0; r < rows; r ++)
	{
	    new string[50];
	    
	    format(string, sizeof(string), "playerMP3_Create", r); cache_get_value_name_int(r, string, playerMP3_Create[playerid][r]);
        format(string, sizeof(string), "playerMP3_Name",r); cache_get_value_name(r, string, playerMP3_Name[playerid][r]);
        format(string, sizeof(string), "playerMP3_Index",r); cache_get_value_name_int(r, string, playerMP3_Index[playerid][r]);
        format(string, sizeof(string), "playerMP3_Url",r); cache_get_value_name(r, string, playerMP3_Url[playerid][r]);
        format(string, sizeof(string), "playerMP3_Title",r); cache_get_value_name(r, string, playerMP3_Title[playerid][r]);
	}
	cache_delete(result);
}

stock mp3DatabaseDelete(playerid, index)
{
    if(playerMP3_Create[playerid][index] == 1)
	{
	    for(new i = index; i < MAX_MP3; i ++)
	    {
	        if(playerMP3_Create[playerid][i+1] == 1)
	        {
			    playerMP3_Create[playerid][i] = NumberNote_Create[playerid][i+1];
				strmid(playerMP3_Name[playerid][i], playerMP3_Name[playerid][i+1], 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
				strmid(playerMP3_Url[playerid][i], playerMP3_Url[playerid][i+1], 0, 128, 128);
			    strmid(playerMP3_Title[playerid][i], playerMP3_Title[playerid][i+1], 0, 50, 50);
		    }
		    else
		    {
		        new string[200];
				format(string, 200, "DELETE FROM `%s` WHERE `playerMP3_Name` = '%s' AND `playerMP3_Index` = '%d' LIMIT 1", MySQL_MP3, PlayerNameEx(playerid), playerMP3_Index[playerid][i]);
				mysql_query(MySQL, string, false);

				playerMP3_Create[playerid][i] = 0;
				playerMP3_Index[playerid][i] = -1;
				strmid(playerMP3_Name[playerid][i], "", 0, MAX_PLAYER_NAME, MAX_PLAYER_NAME);
				strmid(playerMP3_Url[playerid][i], "", 0, 128, 128);
			    strmid(playerMP3_Title[playerid][i], "", 0, 50, 50);
		        break;
		    }
		}
		OnPlayerSave(playerid, 5);
	    return 1;
	}
    return 0;
}

stock atmDatabaseGenerate(objectid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, interior, virtualworld)
{
	for(new i = 0; i < MAX_ATM; i ++)
	{
	    if(ATMInfo[i][atm_create] == 0)
	    {
		    ATMInfo[i][atm_create] = 1;
			ATMInfo[i][atm_index] = i;
			ATMInfo[i][atm_virtualworld] = virtualworld;
			ATMInfo[i][atm_interior] = interior;
			ATMInfo[i][atm_objectid] = objectid;
			ATMInfo[i][atm_position][0] = x;
			ATMInfo[i][atm_position][1] = y;
			ATMInfo[i][atm_position][2] = z;
			ATMInfo[i][atm_position][3] = rx;
			ATMInfo[i][atm_position][4] = ry;
			ATMInfo[i][atm_position][5] = rz;
			
			new Float:pos[2];
			pos[0] = x; pos[1] = y;
			
			pos[0] -= floatmul(0.7, floatsin(-rz, degrees));
			pos[1] -= floatmul(0.7, floatcos(-rz, degrees));
			
			ATMInfo[i][atm_dyobjectid] = CreateDynamicObject(ATMInfo[i][atm_objectid], ATMInfo[i][atm_position][0], ATMInfo[i][atm_position][1], ATMInfo[i][atm_position][2], ATMInfo[i][atm_position][3], ATMInfo[i][atm_position][4], ATMInfo[i][atm_position][5], virtualworld);
			ATMInfo[i][atm_pickupPos][0] = pos[0]; ATMInfo[i][atm_pickupPos][1] = pos[1]; ATMInfo[i][atm_pickupPos][2] = z;
			ATMInfo[i][atm_pickup] = CreatePickup(1239, 1, ATMInfo[i][atm_pickupPos][0], ATMInfo[i][atm_pickupPos][1], ATMInfo[i][atm_pickupPos][2], virtualworld);
			new string[50]; format(string, sizeof(string), "ATM\n[%d]", ATMInfo[i][atm_index]);
			ATMInfo[i][atm_Label] = Create3DTextLabel(string, COLOR_ATM, ATMInfo[i][atm_pickupPos][0], ATMInfo[i][atm_pickupPos][1], ATMInfo[i][atm_pickupPos][2], 10.0, ATMInfo[i][atm_virtualworld]);
			
			new query[200];
            format(query, sizeof(query), "INSERT INTO `%s` (`atm_create`, `atm_index`) VALUES ('%d', '%d')", MySQL_ATM, ATMInfo[i][atm_create], ATMInfo[i][atm_index]);
			mysql_query(MySQL, query, false);
			
			atmDatabaseSave(ATMInfo[i][atm_index]);
			return 1;
		}
	}
	return 0;
}

stock atmDatabaseSave(atmIndex)
{
	if(ATMInfo[atmIndex][atm_create] == 1)
	{
	    new query[500];
	    mysql_format(MySQL, query, sizeof(query), "UPDATE `%s` SET", MySQL_ATM);
	    mysql_format(MySQL, query, sizeof(query), "%s `atm_create` = '%d',",query, ATMInfo[atmIndex][atm_create]);
		mysql_format(MySQL, query, sizeof(query), "%s `atm_index` = '%d',",query, ATMInfo[atmIndex][atm_index]);
		mysql_format(MySQL, query, sizeof(query), "%s `atm_virtualworld` = '%d',",query, ATMInfo[atmIndex][atm_virtualworld]);
		mysql_format(MySQL, query, sizeof(query), "%s `atm_objectid` = '%d',",query, ATMInfo[atmIndex][atm_objectid]);
	    mysql_format(MySQL, query, sizeof(query), "%s `atm_position_0` = '%.4f',",query, ATMInfo[atmIndex][atm_position][0]);
	    mysql_format(MySQL, query, sizeof(query), "%s `atm_position_1` = '%.4f',",query, ATMInfo[atmIndex][atm_position][1]);
	    mysql_format(MySQL, query, sizeof(query), "%s `atm_position_2` = '%.4f',",query, ATMInfo[atmIndex][atm_position][2]);
	    mysql_format(MySQL, query, sizeof(query), "%s `atm_position_3` = '%.4f',",query, ATMInfo[atmIndex][atm_position][3]);
	    mysql_format(MySQL, query, sizeof(query), "%s `atm_position_4` = '%.4f',",query, ATMInfo[atmIndex][atm_position][4]);
	    mysql_format(MySQL, query, sizeof(query), "%s `atm_position_5` = '%.4f'",query, ATMInfo[atmIndex][atm_position][5]);
	    mysql_format(MySQL, query, sizeof(query), "%s WHERE `atm_index` = '%d' LIMIT 1", query, ATMInfo[atmIndex][atm_index]);
	    mysql_query(MySQL, query, false);
	    return 1;
	}
	return 0;
}

stock atmDatabaseLoads()
{
	for(new atmIndex = 0; atmIndex < MAX_ATM; atmIndex ++)
	{
	    new query[200];
		mysql_format(MySQL, query, sizeof(query), "SELECT * FROM `%s` WHERE `atm_index` = '%d' LIMIT 1", MySQL_ATM, atmIndex);
		new Cache:result = mysql_query(MySQL, query, true);
		
		if(cache_num_rows())
		{
		    cache_get_value_name_int(0, "atm_create", ATMInfo[atmIndex][atm_create]);
	        cache_get_value_name_int(0, "atm_index", ATMInfo[atmIndex][atm_index]);
	        cache_get_value_name_int(0, "atm_virtualworld", ATMInfo[atmIndex][atm_virtualworld]);
	        cache_get_value_name_int(0, "atm_objectid", ATMInfo[atmIndex][atm_objectid]);
	        cache_get_value_name_float(0, "atm_position_0", ATMInfo[atmIndex][atm_position][0]);
	        cache_get_value_name_float(0, "atm_position_1", ATMInfo[atmIndex][atm_position][1]);
	        cache_get_value_name_float(0, "atm_position_2", ATMInfo[atmIndex][atm_position][2]);
	        cache_get_value_name_float(0, "atm_position_3", ATMInfo[atmIndex][atm_position][3]);
	        cache_get_value_name_float(0, "atm_position_4", ATMInfo[atmIndex][atm_position][4]);
	        cache_get_value_name_float(0, "atm_position_5", ATMInfo[atmIndex][atm_position][5]);
	        
	        new Float:pos[2];
			pos[0] = ATMInfo[atmIndex][atm_position][0]; pos[1] = ATMInfo[atmIndex][atm_position][1];
			
			pos[0] -= floatmul(0.7, floatsin(-ATMInfo[atmIndex][atm_position][5], degrees));
			pos[1] -= floatmul(0.7, floatcos(-ATMInfo[atmIndex][atm_position][5], degrees));

			ATMInfo[atmIndex][atm_dyobjectid] = CreateDynamicObject(ATMInfo[atmIndex][atm_objectid], ATMInfo[atmIndex][atm_position][0], ATMInfo[atmIndex][atm_position][1], ATMInfo[atmIndex][atm_position][2], ATMInfo[atmIndex][atm_position][3], ATMInfo[atmIndex][atm_position][4], ATMInfo[atmIndex][atm_position][5], ATMInfo[atmIndex][atm_virtualworld]);
			ATMInfo[atmIndex][atm_pickupPos][0] = pos[0]; ATMInfo[atmIndex][atm_pickupPos][1] = pos[1]; ATMInfo[atmIndex][atm_pickupPos][2] = ATMInfo[atmIndex][atm_position][2];
			ATMInfo[atmIndex][atm_pickup] = CreatePickup(1239, 1, ATMInfo[atmIndex][atm_pickupPos][0], ATMInfo[atmIndex][atm_pickupPos][1], ATMInfo[atmIndex][atm_pickupPos][2], ATMInfo[atmIndex][atm_virtualworld]);
			new string[50]; format(string, sizeof(string), "ATM\n[%d]", ATMInfo[atmIndex][atm_index]);
			ATMInfo[atmIndex][atm_Label] = Create3DTextLabel(string, COLOR_ATM, ATMInfo[atmIndex][atm_pickupPos][0], ATMInfo[atmIndex][atm_pickupPos][1], ATMInfo[atmIndex][atm_pickupPos][2], 10.0, ATMInfo[atmIndex][atm_virtualworld]);
		}
		cache_delete(result);
	}
}

stock VehiclePlateCreate(plate)
{
    new query[200];

	while(plate > 0)
	{
		format(query, sizeof(query), "SELECT `vPlate` FROM `%s` WHERE `vPlate` = '%d' LIMIT 1", MySQL_VEHICLE, plate);
		new Cache:result = mysql_query(MySQL, query, true);

		if(!cache_num_rows())
		{
			cache_delete(result);
			break;
		}
		cache_delete(result);
	}
	return plate;
}


stock vehicleGenerate(playerid, modelID, Float:x, Float:y, Float:z, Float:angle, interior, virtualWorld) // 차량 구매 및 추가
{
	new ve = CreateVehicleEx(modelID, x, y, z, angle, interior, virtualWorld, 0,0, 0,0);
	strcpy(VehicleInfo[ve][vOwner], PlayerInfo[playerid][pName], MAX_PLAYER_NAME);

	new query[200];
	format(query, sizeof(query),
		"INSERT INTO `%s` (`vCreate`, `vModel`, `vPlate`, `vOwner`) VALUES ('%d', '%d', '%s', '%s')",
		MySQL_VEHICLE, VehicleInfo[ve][vCreate], VehicleInfo[ve][vModel], VehicleInfo[ve][vPlate], VehicleInfo[ve][vOwner]);
	new Cache:result = mysql_query(MySQL, query, true);
	VehicleInfo[ve][vID] = cache_insert_id();
	cache_delete(result);
	vehicleSave( ve );
}

stock vehicleSave(ve)
{
    new query[512];
	mysql_format(MySQL, query, sizeof(query), "UPDATE `%s` SET", MySQL_VEHICLE);
	mysql_format(MySQL, query, sizeof(query), "%s `id` = '%d',", query, VehicleInfo[ve][vID]);
	mysql_format(MySQL, query, sizeof(query), "%s `vHealth` = '%f',", query, VehicleInfo[ve][vHealth]);
	mysql_format(MySQL, query, sizeof(query), "%s `vFuel` = '%d',", query, VehicleInfo[ve][vFuel]);

	mysql_format(MySQL, query, sizeof(query), "%s `vPosition_0` = '%f',", query, VehicleInfo[ve][vPosition][0]);
	mysql_format(MySQL, query, sizeof(query), "%s `vPosition_1` = '%f',", query, VehicleInfo[ve][vPosition][1]);
	mysql_format(MySQL, query, sizeof(query), "%s `vPosition_2` = '%f',", query, VehicleInfo[ve][vPosition][2]);
	mysql_format(MySQL, query, sizeof(query), "%s `vAngle` = '%f',", query, VehicleInfo[ve][vAngle]);

	mysql_format(MySQL, query, sizeof(query), "%s `vInterior` = '%d',", query, VehicleInfo[ve][vInterior]);
	mysql_format(MySQL, query, sizeof(query), "%s `vVirtualWorld` = '%d',", query, VehicleInfo[ve][vVirtualWorld]);

	mysql_format(MySQL, query, sizeof(query), "%s `vColor_0` = '%d',", query, VehicleInfo[ve][vColor][0]);
	mysql_format(MySQL, query, sizeof(query), "%s `vColor_1` = '%d',", query, VehicleInfo[ve][vColor][1]);

	mysql_format(MySQL, query, sizeof(query), "%s `vFaction` = '%d',", query, VehicleInfo[ve][vFaction]);
	mysql_format(MySQL, query, sizeof(query), "%s `vFactionIndex` = '%d',", query, VehicleInfo[ve][vFactionIndex]);

	mysql_format(MySQL, query, sizeof(query), "%s `vBlow` = '%d',", query, VehicleInfo[ve][vBlow]);
	mysql_format(MySQL, query, sizeof(query), "%s `vEngine` = '%d',", query, VehicleInfo[ve][vEngine]);
	mysql_format(MySQL, query, sizeof(query), "%s `vLock` = '%d',", query, VehicleInfo[ve][vLock]);

	mysql_format(MySQL, query, sizeof(query), "%s `vOwner` = '%d'", query, VehicleInfo[ve][vOwner]);
	mysql_format(MySQL, query, sizeof(query), "%s WHERE `vPlate` = '%s'", query, VehicleInfo[ve][vPlate]);
	mysql_format(MySQL, query, sizeof(query), "%s", query);
    mysql_query(MySQL, query, false);

}

stock vehicleLoadToPlayer(playerid)
{

	new query[100];
	format(query, sizeof(query), "SELECT * FROM `%s` WHERE `vOwner` = '%s' LIMIT '%d'", MySQL_VEHICLE, PlayerInfo[playerid][pName], MAX_OWNER_VEHICLES);
	new Cache:result = mysql_query(MySQL, query, true);

	new rows = cache_num_rows();
	if (!rows)
		return -1;

	new tmp_VehicleInfo[vInfo];

	for(new i=0, j=rows; i<j; i++)
	{
		cache_get_value_name_int(i, "vCreate", tmp_VehicleInfo[vCreate]);
		cache_get_value_name_int(i, "vModel", tmp_VehicleInfo[vModel]);

		cache_get_value_name_int(i, "id", tmp_VehicleInfo[vID]);
		cache_get_value_name_float(i, "vHealth", tmp_VehicleInfo[vHealth]);
		cache_get_value_name_int(i, "vFuel", tmp_VehicleInfo[vFuel]);

		cache_get_value_name_float(i, "vPosition_0", tmp_VehicleInfo[vPosition][0]);
		cache_get_value_name_float(i, "vPosition_1", tmp_VehicleInfo[vPosition][1]);
		cache_get_value_name_float(i, "vPosition_2", tmp_VehicleInfo[vPosition][2]);
		cache_get_value_name_float(i, "vAngle", tmp_VehicleInfo[vAngle]);

		cache_get_value_name_int(i, "vInterior", tmp_VehicleInfo[vInterior]);
		cache_get_value_name_int(i, "vVirtualWorld", tmp_VehicleInfo[vVirtualWorld]);

		cache_get_value_name_int(i, "vColor_0", tmp_VehicleInfo[vColor][0]);
		cache_get_value_name_int(i, "vColor_1", tmp_VehicleInfo[vColor][1]);

		cache_get_value_name_int(i, "vFaction", tmp_VehicleInfo[vFaction]);
		cache_get_value_name_int(i, "vFactionIndex", tmp_VehicleInfo[vFactionIndex]);

		cache_get_value_name_int(i, "vBlow", tmp_VehicleInfo[vBlow]);
		cache_get_value_name_int(i, "vEngine", tmp_VehicleInfo[vEngine]);
		cache_get_value_name_int(i, "vLock", tmp_VehicleInfo[vLock]);

		cache_get_value_name(i, "vOwner", tmp_VehicleInfo[vOwner]);
		cache_get_value_name(i, "vPlate", tmp_VehicleInfo[vPlate]);



		new ve = CreateVehicleEx(tmp_VehicleInfo[vModel],
			tmp_VehicleInfo[vPosition][0], tmp_VehicleInfo[vPosition][1], tmp_VehicleInfo[vPosition][2], tmp_VehicleInfo[vAngle],
			tmp_VehicleInfo[vInterior], tmp_VehicleInfo[vVirtualWorld],
			tmp_VehicleInfo[vColor][0], tmp_VehicleInfo[vColor][1], 0,0);

		SetVehicleNumberPlate(ve, tmp_VehicleInfo[vPlate]);

		SetVehiclePos(vehicleid, tmp_VehicleInfo[vPosition][0], tmp_VehicleInfo[vPosition][1], tmp_VehicleInfo[vPosition][2]);
		LinkVehicleToInterior(vehicleid, tmp_VehicleInfo[vInterior]);
		SetVehicleVirtualWorld(vehicleid, tmp_VehicleInfo[vVirtualWorld]);

		VehicleInfo[ve] = tmp_VehicleInfo;

		//printf("ve=%d ID = %d / copyID=%d", ve, VehicleInfo[ve][vID], tmp_VehicleInfo[vID]);
	}
	cache_delete(result);
}

stock removeVehicleToPlayer(playerid)
{
	for(new i=1, j=MAX_VEHICLES i<j; i++)
	{
		if (VehicleInfo[i][vCreate] == 1)
		{
			if (!strcmp(VehicleInfo[i][vOwner], PlayerInfo[playerid][pName], true))
			{
				resetVehicle(i);
				DestroyVehicle(i);
			}
		}
	}
}

stock DateDecryption(text[], &year, &month, &day, &hour, &minute, &second)
{
    new temp[2][50], array[5][5];
    new index;
    
	for(new i = 0; i < strlen(text); i ++)
	{
	    if(text[i] == ' ')
	    {
	        index = i;
	    }
	}
	strmid(temp[0], text, 0, index, 50); strmid(temp[1], text, index+1, 50, 50);
	
	split(text[0], array, '-');
	year = strval(array[0]); month = strval(array[1]); day = strval(array[2]);
	split(text[1], array, '-');
	hour = strval(array[0]); minute = strval(array[1]); second = strval(array[2]);
}

stock DateInsert(year, month, day, hour, minute, second)
{
	if(second == -1) second = 0;
	
	new string[50];
	format(string, sizeof(string), "%d-%d-%d %d-%d-%d", year, month, day, hour, minute, second);
	return string;
}

stock CreateTextPickup(pickupid, Float:x, Float:y, Float:z, text[], Float:distance, virtualworld = 0)
{
	if(!strlen(text)) return print("Textpick Error [text blank error]");
    CreatePickup(pickupid, 1, x, y, z, 0);
    Create3DTextLabel(text, COLOR_WHITE2, x, y, z, distance, virtualworld);
    return 1;
}

stock resetVar()
{
    new atm_reset[atm_Info];
    new build_reset[bInfo];
    new vehicle_reset[vInfo];
	for(new i = 0; i < MAX_ATM; i ++)
	{
		atm_reset[atm_index] = -1;
		ATMInfo[i] = atm_reset;
	}
	for(new i = 0; i < MAX_BUILD; i ++)
	{
		build_reset[bInPickup] = -1;
		build_reset[bOutPickup] = -1;
		BuildInfo[i] = build_reset;
		
		BuildInfo[i][bInTextLabelID] = Text3D:-1;
	}
	for(new i = 0; i < MAX_VEHICLES; i ++)
	{
	    vehicle_reset[vOwner] = -1;
		VehicleInfo[i] = vehicle_reset;
	}
}

stock buildLabelStyle(index)
{
    new string[128];
    format(string, sizeof(string), "%d\n건물 오류", BuildInfo[index][bNumber]);
	if(BuildInfo[index][bCreate] == 1)
	{
	    format(string, sizeof(string), "[%d]\n%s\n소유자 : %s", BuildInfo[index][bNumber], BuildInfo[index][bName], BuildInfo[index][bOwner]);
	}
	return string;
}

stock CreateVehicleEx(modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, spawnTime, type)
{
    new ve = CreateVehicle(modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, spawnTime);
    resetVehicle(ve);

    VehicleInfo[ve][vCreate] = 1;
    VehicleInfo[ve][vModel] = modelid;
    VehicleInfo[ve][vPosition][0] = x; VehicleInfo[ve][vPosition][1] = y; VehicleInfo[ve][vPosition][2] = z;
    VehicleInfo[ve][vAngle] = angle;
    
    if(type == 0){ }
    return ve;
}

stock resetVehicle(vehicleid)
{
    new vehicle_reset[vInfo];
	vehicle_reset[vOwner] = -1;
	VehicleInfo[vehicleid] = vehicle_reset;
}

stock strcpy(dest[], const source[], maxlength=sizeof dest)
{
	strcat((dest[0] = EOS, dest), source, maxlength);
}
