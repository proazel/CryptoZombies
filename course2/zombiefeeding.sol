pragma solidity ^0.4.19;

 // component 나누는 것 처럼 contract 분할
import "./zombiefactory.sol"; // import

// interface 정의, 중괄호를 사용하지 않고, (); 사용
contract KittyInterface {
    function getKitty(uint256 _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );
}

// 새 contract를 생성 할 때 is [contract명]으로 기존 contract 상속 가능
// 상속 받은 contract 내 함수 사용 가능
contract ZombieFeeding is ZombieFactory{
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d; // cryptoKitty의 contract 주소
    KittyInterface kittyContract = KittyInterface(ckAddress); // kittyContact라는 Kittyinterface를 생성하고, ckAddress로 초기화

    /*
        1 storage
        * 블록체인 상 영구 저장되는 변수
        * 함수 외부에 선언 된 변수(상태 변수)는 storage로 자동 설정
        * == 하드디스크

        2 memory
        * 임시 저장되는 변수로, contract 함수에 대한 외부 호출이 일어나면 지워짐
        * 함수 내부에 선언 된 변수는 memory로 자동 설정
        * == RAM
    */
    function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) public {
        // msg.sender가 zombieToOwner의 id와 동일하게
        require(msg.sender == zombieToOwner[_zombieId]);
        
        // myZombie라는 Zombie형 변수를 storage로 선언, 이 변수에 zombies 배열의 _zombideid 인덱스가 가진 값을 저장
        Zombie storage myZombie = zombies[_zombieId];

        _targetDna = _targetDna % dnaModulus; // 16자리 숫자
        uint newDna = (myZombie.dna + _targetDna) / 2; // 문 좀비와 물린 좀비의 dna값의 평균값을 변수에 저장
        
        if (keccak256(_species) == keccak256("kitty")) { // 각각의 keccak256 해시값 비교
            newDna = newDna - newDna % 100 + 99; // DNA 마지막 2자리를 99로 대체하는 로직
            /*
                newDna가 112233일 경우 newDna % 33 = 33
                따라서 newDna - newDna % 100 = 112200
                여기에 원하는 두 자리 숫자를 더하면, 1122(원하는두자리숫자)가 됨
            */
        }

        // 좀비가 물었으니 zombiefactory.sol에 있는 새 좀비를 만드는 함수 실행, 인자값은 1: _name 2: _dna
        _createZombie("NoName", newDna);
    }

    // 고양이 유전자를 얻어내는 함수
    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna; // 변수 선언
        
        // kittyContract.getKitty(_Id); // 함수 호출, 다수의 변수 반환
        // 그 중 10번째 반환되는 변수 kittyDna에 genes 저장
        (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);

        feedAndMultiply(_zombieId, kittyDna, "kitty"); // 함수 호출
    }
}