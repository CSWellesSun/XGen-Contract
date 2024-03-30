module xgen_addr::contract {
    use aptos_std::table::{Self, Table};
    use std::signer;

    const E_NOT_INTIALIZED: u64 = 1;

    struct ContractList has key {
        // for more future agents
        contracts: Table<u64, Contract>,
        contract_counter: u64
    }

    struct Contract has store, drop, copy {
        contract_id: u64,
        address: address,
    }

    public fun create_list(account: &signer) {
        let contracts_holder = ContractList {
            contracts: table::new(),
            contract_counter: 0
        };
        move_to(account, contracts_holder);
    }

    public fun create_contract(account: &signer) acquires ContractList {
        let signer_address = signer::address_of(account);
        assert!(exists<ContractList>(signer_address), E_NOT_INTIALIZED);
        let contract_list = borrow_global_mut<ContractList>(signer_address);
        let counter = contract_list.contract_counter + 1;
        let new_contract = Contract {
            contract_id: counter,
            address: signer_address
        };
        table::upsert(&mut contract_list.contracts, counter, new_contract);
        contract_list.contract_counter = counter;
    }
}