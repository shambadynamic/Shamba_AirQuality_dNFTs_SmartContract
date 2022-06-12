from brownie import PolyAirQuality, config, accounts

def main():
    deployer_account = accounts.add(
        config["wallets"]["from_key"]) or accounts[0]
    print(deployer_account.address)
    contract = PolyAirQuality[-1]
    contract.update_dNFT({'from': deployer_account})
    