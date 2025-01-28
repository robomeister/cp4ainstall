if [ "$#" -ne 3 ]; then
    echo "Usage: copySecret.sh <secret-name> <old-namespace> <new-namespace>"
    exit 1
fi


sedString="s/$2/$3/g"
kc -n $2 get secret $1 -o yaml | sed $sedString | kc -n $3 create -f -
