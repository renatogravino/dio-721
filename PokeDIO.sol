// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract PokeDIO is ERC721 {
    struct Pokemon {
        string name;
        uint256 level;
        string img;
    }

    Pokemon[] public pokemons;
    address public gameOwner;

    constructor() ERC721("PokeDio", "PKD") {
        gameOwner = msg.sender;
    }

    modifier onlyOwnerOf(uint256 _monsterID) {
        require(
            ownerOf(_monsterID) == msg.sender,
            "Apenas o dono pode batalhar com este pokemon"
        );
        _;
    }

    function battle(uint256 _attackingPokemon, uint256 _defendingPokemon)
        public
        onlyOwnerOf(_attackingPokemon)
    {
        Pokemon storage attacker = pokemons[_attackingPokemon];
        Pokemon storage defender = pokemons[_defendingPokemon];

        if (attacker.level >= defender.level) {
            attacker.level += 2;
            defender.level += 1;
        } else {
            attacker.level += 1;
            defender.level += 2;
        }
    }

    function createNewPockemon(
        string memory _name,
        address _to,
        string memory _img
    ) public {
        require(
            msg.sender == gameOwner,
            "Apenas o dono do jogo pode criar pokemons"
        );
        uint256 id = pokemons.length;
        pokemons.push(Pokemon(_name, 1, _img));
        _safeMint(_to, id);
    }
}
