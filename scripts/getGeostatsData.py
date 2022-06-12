from brownie import PolyAirQuality, config, accounts

def printGeoData(contract):

    if contract.getGeostatsData() != 0:
        print(contract.getGeostatsData())
    else:
        print("Data isn't available yet. Please check the job run in the oracle node.")
        
def printCids(contract):

    i = 0
    while True:
    
        if contract.getCid(i):
            print(contract.getCid(i))
        else:
            break
        i += 1

def main():
    deployer_account = accounts.add(config["wallets"]["from_key"]) or accounts[0]
    print(deployer_account.address)
    contract = PolyAirQuality[-1]
    printGeoData(contract)
    printCids(contract)