# SUBLEX - A program for deriving sublexical units from the CELEX lexical database

#    This file is part of SUBLEX.
#    Copyright 2006 Markus Hofmann, SUBLEX v0.1

#    SUBLEX is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.

#    SUBLEX is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.

#    You should have received a copy of the GNU General Public License
#    along with SUBLEX; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA


# NOTES:

# For easier understanding the order of all Steps (Scripts, input and output files) were numbered initially, N1 ... when 10 steps were full, I began numbering with O0..O1 and P0 ...P3. If you sort the files in the folder by name, after you have run SUBLEX, you get an alphabetical and thus chronological sorted list of all steps!
#(Note that some of these Letters and Numbers are assigned with two scripts and others, e.g. P0, are missing)


# dependencies: PERL, sort and join (Versions that are installed on OsX 10.3.9)
# if any argument is given after N0supershell the initial corpus reading is left out


# 1. Provide comparable initial lists


perl N1wordextGOL.pl

perl N1wordextGOW.pl

perl N1wordextGPL.pl 

perl N1wordextGPW.pl 


echo Step 1 finished, if you see this statement standing alone! N2-files are now available!


######################

# 2. 

# N2GOL.txt, N2GOW.txt, N2GPL.txt and N2GPW.txt should have been generated!
#####################

# 3. Rejection of acute accents: Rejection based on orthography!

perl N3TildOutOrth.pl -i N2GOL.txt -o N4GOL.txt -a N4GOL-rejected.txt

perl N3TildOutOrth.pl -i N2GOW.txt -o N4GOW.txt -a N4GOW-rejected.txt


######################
echo Orthographic rejection criteria applied

# 4. N4GOW.txt und N4GOL.txt are now available

######################

# NOTE4ME: N5PhonRejLem.pl wurde erst umbenannt, denk aber es mŸsst pass 

# 5. Phonological rejection! (s. main text of the paper or script for details)

perl N5PhonRejLem.pl -i N2GPL.txt -o N6GPL.txt -a N6GPL-rejected.txt

perl N5PhonRejWF.pl -i N2GPW.txt -o N6GPW.txt -a N6GPW-rejected.txt

#####################

#6. Phonological Rejection Files and surviving words and phrases are in N6GPL.txt and N6GPW.txt

echo Phonological rejection criteria applied

####################

#7.  Join orthographic and phonological rejection criteria to provide a purified Lemma and Wordform database!



join  N4GOL.txt N6GPL.txt>N8Lem.txt

join  N4GOW.txt N6GPW.txt>N8WF.txt

######

#7b. Only when orthographic and phonological syllables have the same number they are acceptet ( e.g. 962 ac-ces-soire 2 [ak][sE[s]á][µ][r@] 2 was excluded)

perl N7compSil.pl -i N8Lem.txt -o N8LemS.txt -a N7LemSamExcl.txt

perl N7compSil.pl -i N8WF.txt -o N8WFS.txt -a N7WFSamExcl.txt

##########################
#7c. Compare for the wordforms the number of phonological words and orthographic words, if they not equal, exclude:

perl N7compWord.pl -i N8WFS.txt -o N8WFW.txt -a N7LemWoExcl.txt


##########################
# In the paper at this place the transformation of phrases into words are mentioned. Practically, there is no difference whether the computation is done now or later, as only replacement operations are done in between.
# The entry decomposition for syllables is done in the step at which syllables are extracted (#16 )from the wordform corpus.
# For Single and Dual-Units a seperate step was done separately (see #17). 

###################

# 8. An adjusted Lemma and Word Database is now available!

echo Foreign words excluded from both, the lemma and wordform corpus.
echo and excluded if the phonological and orthographic syllable numbers did not match 
####################
# 9. Skripts to replace "umlaute" and uppercase letters

perl N9Uml_GrosKlein.pl -i N8LemS.txt -o O0Lem.txt

perl N9Uml_GrosKlein.pl -i N8WFW.txt -o O0WF.txt


##################

# 10. "Umlaute" and upper-to-lowercase conversion finished

echo Umlaute and upper-to-lowercase conversion finished 

################

# 11. Ersetzen der langen Vokale

perl O1LongVowels.pl -i O0Lem.txt -o O2Lem_longVRaus.txt

perl O1LongVowels.pl -i O0WF.txt -o O2WF_longVRaus.txt 

#################

#12. Long Vowels replaced

echo Long spoken Vowels were replaced and will thus be treated as separate phonemes.

#################

#13.Phonemes that belong to two syllables are attributed to both of them
# and each Syllable is written in one line with the respective Frequency
# for debugging, s.a. X-OLDIMPORTANT/Xhalbs3.pl: provides more control but 
# does the same

perl O3PhSylZerl.pl -i O2Lem_longVRaus.txt -o O4PhonSylLem.txt

perl O3PhSylZerl.pl -i O2WF_longVRaus.txt -o O4PhonSylWF.txt

# 14. OUTPUT FILES

# 15 Orthographic Syllables Splitting

perl O5OrtSylZerl.pl -i O2Lem_longVRaus.txt -o O6OrthSyllLem.txt

perl O5OrtSylZerl.pl -i O2WF_longVRaus.txt -o O6OrthSyllWF.txt

# The script also provides the Checksums:

echo Phonological Lemma database provided
wc -l O4PhonSylLem.txt
echo syllables
echo Phonological wordform database provided
wc -l O4PhonSylWF.txt
echo syllables
echo Orthographic Lemma database provided
wc -l O6OrthSyllLem.txt
echo syllables
echo Orthographic Wordform database provided
wc -l O6OrthSyllWF.txt
echo syllables



#=====> SYLLABLE LIST!!!!!!!!!!!!!

################################################## 

#17. Wordforms (Phrases) which contained more than one word were divided into separate lines one word per line for wordforms included

# Phonological:

perl O7PWorZ.pl -i O2WF_longVRaus.txt -o O8WFPhonSW.txt

# Orthographic:


perl O7OWorZ.pl -i O2WF_longVRaus.txt -o O8WFOrthSW.txt

##################################################
# 18. Write each entry of the Lemma Databases in one line (Phon/Orth)

perl O8splitline.pl -i O2Lem_longVRaus.txt -o O8LemOrthSW.txt -p O8LemPhonSW.txt

###################################################

# 19A. Annihilate all Separators [, ], -, and =

perl O9SeparAnnil.pl -i O8WFPhonSW.txt -o O8WFPhonSWA.txt
perl O9SeparAnnil.pl -i O8WFOrthSW.txt -o O8WFOrthSWA.txt
perl O9SeparAnnil.pl -i O8LemOrthSW.txt -o O8LemOrthSWA.txt
perl O9SeparAnnil.pl -i O8LemPhonSW.txt -o O8LemPhonSWA.txt



# 19B. Dual Unit-Splitting: Biphonemes and Bigrams

perl O9zerleg.pl -i O8LemOrthSWA.txt -o O9BiOLem.txt
perl O9zerleg.pl -i O8WFOrthSWA.txt -o O9BiOWF.txt
perl O9zerleg.pl -i O8LemPhonSWA.txt -o O9BiPLem.txt
perl O9zerleg.pl -i O8WFPhonSWA.txt -o O9BiPWF.txt

#=======> DUAL-UNIT LIST

# Here the number of the Bigrams are given (for checking and debugging purposes)
echo BiLetter Lemma number
wc -l O9BiOLem.txt
echo BiLetters Wordform number
wc -l O9BiOWF.txt
echo BiPhoneme Lemma number
wc -l O9BiPLem.txt
echo BiPhoneme Wordform number
wc -l O9BiPWF.txt

##################################################

# 20. Single Unit Splitting Phonemes and Letters:

perl P1PhonZerl.pl -i O8LemOrthSWA.txt -o P1LemLet.txt
perl P1PhonZerl.pl -i O8WFOrthSWA.txt -o P1WFLet.txt
perl P1PhonZerl.pl -i O8LemPhonSWA.txt -o P1LemPhon.txt
perl P1PhonZerl.pl -i O8WFPhonSWA.txt  -o P1WFPhon.txt

echo single Units generated 

echo Lemma Letter
wc -l P1LemLet.txt
echo Wordform Letter
wc -l P1WFLet.txt
echo Lemma Phoneme
wc -l P1LemPhon.txt
echo Wordform Phoneme
wc -l P1WFPhon.txt


#=======> SINGLE-UNIT LIST

################
# 21 Sorting of all lists 

#Syllables

sort O4PhonSylLem.txt > P2PhonSylLem_sort.txt
sort O4PhonSylWF.txt > P2PhonSylWF_sort.txt
sort O6OrthSyllLem.txt > P2OrthSyllLem_sort.txt
sort O6OrthSyllWF.txt > P2OrthSyllWF_sort.txt

#Dual Unit

sort O9BiOLem.txt > P2BiOLem_sort.txt
sort O9BiOWF.txt > P2BiOWF_sort.txt
sort O9BiPLem.txt > P2BiPLem_sort.txt
sort O9BiPWF.txt > P2BiPWF_sort.txt
	
#Single Unit
sort P1LemLet.txt > P2LemLet_sort.txt
sort P1WFLet.txt > P2WFLet_sort.txt
sort P1LemPhon.txt > P2LemPhon_sort.txt
sort P1WFPhon.txt > P2WFPhon_sort.txt

echo all lists sorted and now counting

##########################
# 22. Count the number of the units

#Syllable

perl P2CountUnit.pl -i P2PhonSylLem_sort.txt -o P2PhonSylLem_numb.txt
perl P2CountUnit.pl -i P2PhonSylWF_sort.txt -o P2PhonSylWF_numb.txt
perl P2CountUnit.pl -i P2OrthSyllLem_sort.txt -o P2OrthSyllLem_numb.txt
perl P2CountUnit.pl -i P2OrthSyllWF_sort.txt -o P2OrthSyllWF_numb.txt

#Dual Unit

perl P2CountUnit.pl -i P2BiOLem_sort.txt -o P2BiOLem_numb.txt
perl P2CountUnit.pl -i P2BiOWF_sort.txt -o P2BiOWF_numb.txt
perl P2CountUnit.pl -i P2BiPLem_sort.txt -o P2BiPLem_numb.txt
perl P2CountUnit.pl -i P2BiPWF_sort.txt -o P2BiPWF_numb.txt
	
#Single Unit
perl P2CountUnit.pl -i P2LemLet_sort.txt -o P2LemLet_numb.txt
perl P2CountUnit.pl -i P2WFLet_sort.txt -o P2WFLet_numb.txt
perl P2CountUnit.pl -i P2LemPhon_sort.txt -o P2LemPhon_numb.txt
perl P2CountUnit.pl -i P2WFPhon_sort.txt -o P2WFPhon_numb.txt

echo Units counted now replacing finally long vowels and more

#######################
#23. Replace Umlaute and long vowels back and finished

perl P3Rersetz.pl -i  P2PhonSylLem_numb.txt -o P2PhonSylLem_FINAL.txt
perl P3Rersetz.pl -i  P2PhonSylWF_numb.txt -o P2PhonSylWF_FINAL.txt
perl P3Rersetz.pl -i  P2OrthSyllLem_numb.txt -o P2OrthSyllLem_FINAL.txt 
perl P3Rersetz.pl -i  P2OrthSyllWF_numb.txt -o P2OrthSyllWF_FINAL.txt 

#Dual Unit

perl P3Rersetz.pl -i  P2BiOLem_numb.txt -o P2BiOLem_FINAL.txt 
perl P3Rersetz.pl -i  P2BiOWF_numb.txt -o P2BiOWF_FINAL.txt 
perl P3Rersetz.pl -i  P2BiPLem_numb.txt -o P2BiPLem_FINAL.txt 
perl P3Rersetz.pl -i  P2BiPWF_numb.txt -o P2BiPWF_FINAL.txt 
	
#Single Unit
perl P3Rersetz.pl -i  P2LemLet_numb.txt -o P2LemLet_FINAL.txt 
perl P3Rersetz.pl -i  P2WFLet_numb.txt -o P2WFLet_FINAL.txt 
perl P3Rersetz.pl -i  P2LemPhon_numb.txt -o P2LemPhon_FINAL.txt 
perl P3Rersetz.pl -i  P2WFPhon_numb.txt -o P2WFPhon_FINAL.txt 


wc -l P2*FINAL.txt


#############################
#24. Counting of "SCH"

perl P4TrigZerl.pl -i O8LemOrthSWA.txt -o P4LemSch.txt

perl P4TrigZerl.pl -i O8WFOrthSWA.txt -o P4WFSch.txt

perl P2CountUnit.pl -i P4LemSch.txt -o P5LemSch_FINAL.txt

perl P2CountUnit.pl -i P4WFSch.txt -o P5WFSch_FINAL.txt



