pragma solidity ^0.4.19;

contract ZombieFactory {
    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    // mapping 선언, (키 => 값), 데이터를 저장하고 검색하는데 이용 됨
    mapping (uint => address) public zombieToOwner; // 좀비 소유자의 주소 추적
    mapping (address => uint) ownerZombieCount; // 소유한 좀비의 숫자 추적

    /*
        함수 접근 제어자
        1 internal
        * 함수가 정의된 contract를 상속하는 contract에서도 접근이 가능
        * 이를 제외하면 private과 동일

        2 external
        * 함수가 contract 바깥에서만 호출될 수 있음
        * contract 내의 다른 함수에 의해 호출될 수 없다는 점을 제외하면 public과 동일
    */
    function _createZombie(string _name, uint _dna) internal { // private => internal로 변경
        uint id = zombies.push(Zombie(_name, _dna)) - 1; // 새 좀비의 id값
        zombieToOwner[id] = msg.sender; // mapping 업데이트, id에 msg.sender 저장
        ownerZombieCount[msg.sender]++; // msg.sender에 따라 owerZombieCount 증가
        NewZombie(id, _name, _dna);
    } 

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        // ownerZombieCount가 0이 아닐 때 return "";로 에러 메시지 발생시키고 함수 정지
        require(ownerZombieCount[msg.sender] == 0); // // 유저 당 좀비 1마리만 생성 가능
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}