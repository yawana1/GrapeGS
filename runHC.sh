echo 'Horizon x Cinerea GBS :: No filters'
python ./VCFcleaning.py \
	-o /media/yn259/data/research/HC/gbs/none \
	-i /media/yn259/data/research/HC/gbs/genotype.vcf \
	-m 1 \
	-f 0 \
	-t 0 \
	-a 4 \
	-v

echo 'Horizon x Illinoisa GBS :: filtered'
python ./VCFcleaning.py \
	-o /media/yn259/data/research/HC/gbs/filtered \
	-i /media/yn259/data/research/HC/gbs/genotype.vcf \
	-m 0.1 \
	-f 0.2 \
	-t 0 \
	-a 2
	
echo 'Horizon x Cinerea haplotype :: No filters'
python ./VCFcleaning.py \
	-o /media/yn259/data/research/HC/rh/none \
	-i /media/yn259/data/research/HC/rh/genotype.vcf \
	-m 1 \
	-f 0 \
	-t 0 \
	-a 4 \
	-v

echo 'Horizon x Cinerea haplotype :: filtered'
python ./VCFcleaning.py \
	-o /media/yn259/data/research/HC/rh/filtered \
	-i /media/yn259/data/research/HC/rh/genotype.vcf \
	-m 0.1 \
	-f 0.2 \
	-t 0 \
	-a 2

echo 'Horizon x Cinerea SNP :: No filters'
python ./VCFcleaning.py \
	-o /media/yn259/data/research/HC/snp/none \
	-i /media/yn259/data/research/HC/snp/genotype.vcf \
	-m 1 \
	-f 0 \
	-t 0 \
	-a 4 \
	-v

echo 'Horizon x Cinerea SNP :: filtered'
python ./VCFcleaning.py \
	-o /media/yn259/data/research/HC/snp/filtered \
	-i /media/yn259/data/research/HC/snp/genotype.vcf \
	-m 0.1 \
	-f 0.2 \
	-t 0 \
	-a 2

echo 'Horizon x Cinerea rQTL'
python ./Gmatrix.py \
	-o /media/yn259/data/research/HC/rqtl \
	-i /media/yn259/data/research/HC/rqtl/genotype.txt
	

:<< 'END'
plink="/home/yn259/apps/plink/plink"
ibis="/home/yn259/apps/ibis/ibis"
map="/home/yn259/apps/ibis/add-map-plink.pl"

echo 'Horizon x Cinerea GBS :: IBIS Without MAP'
dir="/media/yn259/data/research/HC"
phy_ibis="$dir/gbs/phy_ibis"
if [ ! -d "$phy_ibis" ]
then
	echo "creating ibis directory"
	mkdir "$phy_ibis"
fi
$plink --vcf $dir/gbs/genotype.vcf --make-bed --out $phy_ibis/genotype
$ibis -bfile $phy_ibis/genotype -ibd2 -printCoef -t 4 -f $phy_ibis/ibis

echo 'Horizon x Cinerea SNP :: IBIS Without MAP'
dir="/media/yn259/data/research/HC"
phy_ibis="$dir/snp/phy_ibis"
if [ ! -d "$phy_ibis" ]
then
	echo "creating ibis directory"
	mkdir "$phy_ibis"
fi
$plink --vcf $dir/snp/genotype.vcf --make-bed --vcf-half-call m --out $phy_ibis/genotype
$ibis -bfile $phy_ibis/genotype -ibd2 -printCoef -t 4 -f $phy_ibis/ibis

END
