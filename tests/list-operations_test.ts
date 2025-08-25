import { Clarinet, Tx, Chain, Account, types } from 'https://deno.land/x/clarinet@v1.5.4/index.ts';
import { assertEquals } from 'https://deno.land/std@0.170.0/testing/asserts.ts';

Clarinet.test({
    name: "Validate list length functionality",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployerAddress = accounts.get('deployer')!.address;
        const shortList = [1, 2, 3];
        const longList = Array(200).fill(0).map((_, i) => i);

        const block = chain.mineBlock([
            Tx.contractCall('list-operations', 'validate-list-length', 
                [types.list(shortList.map(x => types.uint(x)))], 
                deployerAddress
            ),
            Tx.contractCall('list-operations', 'validate-list-length', 
                [types.list(longList.map(x => types.uint(x)))], 
                deployerAddress
            )
        ]);

        assertEquals(block.receipts[0].result, '(ok true)');
        assertEquals(block.receipts[1].result, '(err u103)');
    }
});

Clarinet.test({
    name: "Calculate average of a list",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployerAddress = accounts.get('deployer')!.address;
        const testList = [10, 20, 30, 40, 50];

        const block = chain.mineBlock([
            Tx.contractCall('list-operations', 'list-average', 
                [types.list(testList.map(x => types.uint(x)))], 
                deployerAddress
            )
        ]);

        assertEquals(block.receipts[0].result, '(ok u30)');
    }
});

Clarinet.test({
    name: "Filter list by threshold",
    async fn(chain: Chain, accounts: Map<string, Account>) {
        const deployerAddress = accounts.get('deployer')!.address;
        const testList = [10, 20, 30, 40, 50];

        const block = chain.mineBlock([
            Tx.contractCall('list-operations', 'filter-list', 
                [
                    types.list(testList.map(x => types.uint(x))), 
                    types.uint(25), 
                    types.ascii('gt')
                ], 
                deployerAddress
            )
        ]);

        const expectedResult = '(ok (30 40 50))';
        assertEquals(block.receipts[0].result, expectedResult);
    }
});