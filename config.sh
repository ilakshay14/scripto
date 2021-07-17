CHOICE=0
CONFIRM="y"
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'
FOLDER_NAME=""
BASE_DIR="/Users/lakshaymalhotra/Documents/workspace"
PACKAGE_INSTALLER='yarn'


REPO_URL="https://github.com/ilakshay14/reactBoilerPlate.git"
BRANCH=""

EchoError() {
    echo -e "${RED}scripto ERROR${NC} $1"
}

EchoInfo() {
    echo -e "${BLUE}scripto INFO${NC} $1"
}

EchoWarning() {
    echo -e "${YELLOW}scripto WARN${NC} $1"
}

ShowMenu () {
    echo ""
    echo "Welcome to Frontend auto setup utility."
    echo ""
    echo "Please choose your config:"
    echo "1. React, Redux, Apollo, GraphQL, Styled Components"
    echo "2. React, Apollo, GraphQL, Styled Components"
    echo "3. React, Redux, Axios, Styled Components"
    echo "4. Exit."
    echo ""
}

SetConfig () {
    case $1 in
        0) EchoError "you have selected an invalid option"
        # "You have selected an Invalid option"
        ;;
        1) echo "you have selected: 1. React, Redux, Apollo, GraphQL, Styled Components?"
        BRANCH="master"
        ;;
        2) echo "you have selected: 2. React, Apollo, GraphQL, Styled Components?"
        BRANCH="react/gqlNoRedux"
        ;;
        3) echo "you have selected: 3. React, Redux, Axios, Styled Components?"
        BRANCH="react/basic"
        ;;
        4) exit 0
        ;;
    esac
}

CreateDirAndClone () {
    EchoInfo "creating directory in ${BASE_DIR}..."
    read -p "enter the new folder name for the project: " -r FOLDER_NAME
    if [ -d "$BASE_DIR/$FOLDER_NAME" ]; then
        EchoError "directory already exists. try again."
        return 128
    else
        command git clone -b $BRANCH $REPO_URL "$BASE_DIR/$FOLDER_NAME"
        return $?
    fi
}

SetPackageInstaller () {
    EchoInfo "checking for yarn..."
    command yarn -v
    if [ $? != 0 ]; then
        EchoWarning "yarn not found"
        EchoInfo "I recommend using yarn."
        EchoInfo "checking for npm..."
        command npm -v
        
        if [ $? != 0 ]; then
            EchoError "npm and yarn both are not installed."
            EchoInfo "please install either yarn or npm. exiting the assistant."
            exit 0;
        else
            PACKAGE_INSTALLER="npm"
        
        fi
    fi    

}

ExecPackageManagerCommands () {
    if [ PACKAGE_INSTALLER == "yarn" ]; then
        # command ${PACKAGE_INSTALLER} && ${PACKAGE_INSTALLER} upgrade
        EchoInfo "exec yarn install..."
        command ${PACKAGE_INSTALLER}
        EchoInfo "exec yarn upgrade..."
        command ${PACKAGE_INSTALLER} upgrade
    else
        EchoInfo "exec npm install..."
        command ${PACKAGE_INSTALLER} install
        EchoInfo "exec npm update..."
        command ${PACKAGE_INSTALLER} update
        EchoInfo "exec npm audit fix..."
        command ${PACKAGE_INSTALLER} audit fix

    fi
}

until [ $CHOICE -eq 4 ]
do
    ShowMenu
    read -p "Enter choice - " -r CHOICE

    SetConfig $CHOICE

    read -p "Please confirm (y/n): " CONFIRM
    if [ $CONFIRM == "y" ]
    then
        SetPackageInstaller
        CreateDirAndClone
        isDirectoryCreated=$?

        if [ $isDirectoryCreated != 0 ]; then
            exit 0
        else
            command cd "$BASE_DIR/$FOLDER_NAME"
            # command yarn && yarn upgrade
            # command ${PACKAGE_INSTALLER} && ${PACKAGE_INSTALLER} upgrade
            ExecPackageManagerCommands
            if [ $? == 0 ]; then
                command code "$BASE_DIR/$FOLDER_NAME"
                exit 0
            else
                echo -e "${RED}error${NC} please check your package.json"
                exit 0;
            fi
        fi
    else
        BRANCH=""
        EchoInfo "you may choose again or exit."
    fi
done
