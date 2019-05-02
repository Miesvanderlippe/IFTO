from string import ascii_lowercase

for driveletter in ascii_lowercase:
    print('KERNEL=="sd' + driveletter + '",ENV{UDISKS_IGNORE}="1"')
    for partition in range(0, 10): 
        print('KERNEL=="sd' + driveletter + str(partition)+ '",ENV{UDISKS_IGNORE}="1"')
