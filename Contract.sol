pragma solidity ^0.4.19; // 버젼 선언

contract ZombiFactory { // contract 생성, class 생성과 비슷함
    // event 선언, 인자값 전달
    event NewZombie(uint zombieId, string name, uint dna);
    
    uint dnaDigits = 16; // uint형 변수 선언
    uint dnaModulus = 10 ** dnaDigits; // uint형 변수 선언, 지수 연산

    struct Zombie { // struct(구조체) 생성
        string name; // string형 변수 선언
        uint dna; // uint형 변수 선언
    }

    // solidity에서 함수는 기본적으로 pbulic
    Zombie[] public zombies; // Zombie struct의 배열을 public으로 생성

    // 함수 생성, 인자값 추가(각 string형, uint형)
    function _createZombie(string _name, uint _dna) private { // private
        /*
            1 == 2

            1
            Person satoshi = Person(172, "Satoshi");
            people.push(satoshi);
            
            2
            people.push(Person(172, "Satoshi"));
        */
        zombies.push(Zombie(_name, _dna)); // zombies 배열 끝에 Zombie 추가
        
        /*
            array.push() : 배열의 새로운 길이를 uint형으로 반환
            배열의 첫 원소가 0이기 때문에, -1이 최신 좀비의 index가 됨
        */
        uint id = zombies.push(Zombie(_name, _dna)) - 1; // 최신 좀비의 id
        NewZombie(id, _name, _dna); // 이벤트 실행, 인자값 전달
    }

    // 함수 생성, 인자값 추가
    // view : 함수가 데이터를 보기만 함, 변경 X
    // pure : 앱 내 어떤 데이터도 접근 불가, 전달 된 인자값에 따라 return(반환값)만 변경
    function _generateRandomDna(string _str) private view returns (uint) { // private
        /*
            이더리움은 keccak256(SHA3)을 내장하고 있음
            keccak256 : 입력 string을 랜덤 256비트 16진수로 매핑  
        */
        
        // _str을 keccak256로 해시값을 받아 의사 난수 16진수 생성 후, 이를 uint형으로 형 변환
        uint rand = uint(keccak256(_str)); 
        //  rand를 % dnaModulus로 연산한 값을 반환
        return rand % dnaModulus; // 16자리 숫자
    }

    // 함수 생성, 인자값 추가
    function createRandomZombie(string _name) public { // public
        uint randDna = _generateRandomDna(_name); // 인자값 전달 받은 함수 호출, uint형 변수에 저장
        _createZombie(_name, randDna); // 함수 호출, 인자값 전달
    }
}