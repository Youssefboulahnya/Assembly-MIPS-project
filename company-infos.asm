.data

chaine0: .asciiz "La liste des employes est:\n"
chaine1: .asciiz "IDs | Noms | Salaires\n"
chaine2: .asciiz "Veuillez saisir l'ID de l'employe rechercher:"
chaine3: .asciiz "\nL'employe recherche est:\n"
chaine4: .asciiz "\nLe salaire Max="
chaine5: .asciiz "\nLe salaire Min="
chaine6: .asciiz "\nLe salaire moyenne est:"
chaine7: .asciiz "\nLe nombre d'employes ayant un salaire superieur au salaire moyenne:\n"
chaine8: .asciiz "\nLa masse salariale de l'entreprise est:"


separateur: .asciiz ":"

nom1: .asciiz "Ali"
nom2: .asciiz "Aya"
nom3: .asciiz "Sara"
nom4: .asciiz "Omar"
nom5: .asciiz "sami"

IDs: .byte 1,2,3,4,5

Salaires: .word 5000,3000,4500,3570,4900

Taille: .word 5

retournligne: .asciiz "\n"

.text
.globl main
main:

la $a0,chaine0
li $v0,4
syscall

la $a0,chaine1
li $v0,4
syscall

#--------------------------------Affichage de la liste des employes:

li $5,0                   #initialiser $5 par 0 pour parcourir la liste des IDs
li $6,0                   #initialiser $6 par 0 pour parcourir la liste des Noms
li $7,0                   #initialiser $7 par 0 pour parcourir la liste des Salaires
lw $8,Taille

affichage:

addi $8,$8,-1

#-------afficher l'IDs
li $v0,1
lb $a0,IDs($5)
syscall


#-------ajouter un separateur pour organiser la liste
li $v0,4
la $a0,separateur
syscall


#-------afficher les Noms
la $a0,nom1($6)
syscall
jal longueur_string             #utiliser la fonction longueur_string pour calculer le longueur du Nom                                  pour passer au nom suivant



li $v0,4
la $a0,separateur
syscall


#-------afficher les salaires
li $v0,1
lw $a0,Salaires($7)
syscall



#-------retourner a la ligne pour afficher l'employe suivant
li $v0,4
la $a0,retournligne
syscall



addi $5,$5,1              #incrementer $5 pour passer au ID suivant
addi $7,$7,4              #incrementer $5 pour passer au Salaire suivant
addi $10,$10,1            #incrementer $10 pour sauter l'espace entre le Noms
add $6,$6,$10             #incrementer $6 pour passer au Nom suivant



bnez $8,affichage        #repeter ces etapes jusq'au la taille est 0





#--------------------------------chercher un employe par son ID:



la $a0,chaine2
li $v0,4
syscall


li $v0,5
syscall
move $11,$v0               #recuperer l'ID entre par l'utilisateur

chercher_employe:


li $a0,0                   #vider le registre a0
li $5,0                    #initialiser $5 pour parcourir la liste des IDs
li $6,0                    #initialiser $5 pour parcourir la liste des Noms
li $7,0                    #initialiser $5 pour parcourir la liste des Salaires




loop:

lb $12,IDs($5)             #charger le premier ID
lw $13,Salaires($7)        #charger le premier Salaire
la $a0,nom1($6)            #charger le premier nom




bne $12,$11,ID_suivant    #tester si on a pas trouve l'ID correspondant au l'ID saisi par                            l'utilisateur


j end                    #si on a le trouver on va l'afficher 



ID_suivant:              #sino , passer au employe suivant
addi $5,$5,1             #passer au l'ID suivant
addi $7,$7,4             #passer au Salaire suivant
jal longueur_string      #sauter au fonction longueur_string pour calculer la longueur du Nom
addi $10,$10,1           #sauter l'espace entre les noms
add $6,$6,$10            #passer au Nom suivant par incrementer R6 par la longueur du Nom precedent
j loop                   #repeter ces etapes 


end:
move $14,$a0             #recuperer le nom d'employe rechercher dan R14

li $v0,4                 #afficher le message chaine3
la $a0,chaine3
syscall


li $v0,1                #afficher l'ID de l'employe recherche
move $a0,$12
syscall

li $v0,4               #un separateur pour organiser l'affichage des information de ce employe
la $a0,separateur
syscall

move $a0,$14           #afficher le nom du employe recherche
syscall

li $v0,4
la $a0,separateur
syscall

li $v0,1              #afficher son salaire
move $a0,$13
syscall



#--------------------------------Calcule_Salaire_Max_Min_Moyenne:

lw $11,Taille

li $7,0
lw $8,Salaires                 #le Max(premier element)
lw $9,Salaires                 #le Min(premier element)
move $12,$9                    #initialiser $12 par 0 pour calculer le Moyenne

loop1:
addi $11,$11,-1
beq $11,$0,end1
addi $7,$7,4
lw $10,Salaires($7)            #charger le salaire suivant


add $12,$12,$10                #calculer la somme des salaires pour calculer leur moyenne apres

bgt $8,$10,NotMax              #tester si Max va changer ou non
move $8,$10                    #si le condition est fausse changer Max


NotMax:
blt $9,$10,NotMin              #tester si Min va changer ou non
move $9,$10                    #si le condition est fausse changer Min

NotMin:
bnez $11,loop1                 #tester si la boucle doit arreter ou non
end1:


li $v0,4
la $a0,chaine4
syscall


li $v0,1                      #afficher le Salaire Max
move $a0,$8
syscall


li $v0,4
la $a0,chaine5
syscall

li $v0,1                      #afficher la salaire Min
move $a0,$9
syscall



Calcule_Salaire_Moyenne:

li $v0,4
la $a0,chaine6
syscall

lw $8,Taille
div $12,$8                     #diviser la somme des salaires calcule pendant la boucle loop2
mflo $a0


li $v0,1
syscall                       #afficher le Salaire Moyenne






#--------------------------------calcule le nbr des employes ayant un Salaire Sup. au Salaire Moyenne:

move $12,$a0          #mettre le salaire moyenne au registre $12 pour l'utiliser dans la condition


li $v0,4
la $a0,chaine7
syscall


li $7,0               #initialiser le nombre des employes par 0
li $5,0               #initialiser R5 par 0 pour parcourir la liste des salaires
li $6,0               #pour calculer la masse salariale apres 



loop2:
addi $8,$8,-1


lw $9,Salaires($5)           #charger le salaire
add $6,$6,$9                 #calculer la somme des salaires pour calculer la masse salariale


blt $9,$12,Non               #tester si le salaire de l'emplpoye actuel est inferieur au salaire                               moyenne
addi $7,$7,1                 #si non incrementer le nbr des employes 

Non:
addi $5,$5,4                 #passer au salaire suivante
bnez $8,loop2                #repeter ces etapes jusqu'au la taille est egal a 0
end2:


li $v0,1                     #afficher le nbr de ces employes
move $a0,$7
syscall



#--------------------------------calcule la masse salariale de l'entreprise:


li $v0,4
la $a0,chaine8
syscall

li $v0,1
move $a0,$6                 #mettre la masse salariale calculer pendant la loop2
syscall                     #afficher la masse salariale



#--------------------------------Quitter le programme


Quitter:
li $v0,10
syscall





longueur_string:
li $10, 0             #initialisation du longueur par 0

count_loop:
lb $t1, 0($a0)        #charger le premier bit du string
beq $t1, $zero, done  #si li bit est 0 quitter le prgm
addi $10, $10, 1      #Incrementer la longueur
addi $a0, $a0, 1      #passer au charactere suivant
j count_loop          #repeter la boucle

done:
jr $ra                #retourne au prgm principale




