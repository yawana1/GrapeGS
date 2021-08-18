echo 'Horizon x Cinerea x Rupestris GBS :: No filters'
python ./VCFcleaning.py \
	-o /media/yn259/data/research/HCR/gbs/none \
	-i /media/yn259/data/research/HCR/gbs/genotype.vcf \
	-m 1 \
	-f 0 \
	-t 0 \
	-a 4 \
	-v

echo 'Horizon x Cinerea x Rupestris GBS :: filtered'
python ./VCFcleaning.py \
	-o /media/yn259/data/research/HCR/gbs/filtered \
	-i /media/yn259/data/research/HCR/gbs/genotype.vcf \
	-m 0.1 \
	-f 0.2 \
	-t 0 \
	-a 2
	
echo 'Horizon x Cinerea x Rupestris haplotype :: No filters'
python ./VCFcleaning.py \
	-o /media/yn259/data/research/HCR/rh/none \
	-i /media/yn259/data/research/HCR/rh/genotype.vcf \
	-m 1 \
	-f 0 \
	-t 0 \
	-a 4 \
	-v

echo 'Horizon x Cinerea x Rupestris haplotype :: filtered'
python ./VCFcleaning.py \
	-o /media/yn259/data/research/HCR/rh/filtered \
	-i /media/yn259/data/research/HCR/rh/genotype.vcf \
	-m 0.1 \
	-f 0.2 \
	-t 0 \
	-a 2

echo 'Horizon x Cinerea x Rupestris SNP :: No filters'
python ./VCFcleaning.py \
	-o /media/yn259/data/research/HCR/snp/none \
	-i /media/yn259/data/research/HCR/snp/genotype.vcf \
	-m 1 \
	-f 0 \
	-t 0 \
	-a 4 \
	-v

echo 'Horizon x Cinerea x Rupestris SNP :: filtered'
python ./VCFcleaning.py \
	-o /media/yn259/data/research/HCR/snp/filtered \
	-i /media/yn259/data/research/HCR/snp/genotype.vcf \
	-m 0.1 \
	-f 0.2 \
	-t 0 \
	-a 2


:<< 'END'
plink="/home/yn259/apps/plink/plink"
ibis="/home/yn259/apps/ibis/ibis"
map="/home/yn259/apps/ibis/add-map-plink.pl"

echo 'Horizon x Cinerea x Rupestris GBS :: IBIS Without MAP'
dir="/media/yn259/data/research/HCR"
phy_ibis="$dir/gbs/phy_ibis"
if [ ! -d "$phy_ibis" ]
then
	echo "creating ibis directory"
	mkdir "$phy_ibis"
fi
$plink --vcf $dir/gbs/genotype.vcf --make-bed --out $phy_ibis/genotype
$ibis -bfile $phy_ibis/genotype -ibd2 -printCoef -t 4 -f $phy_ibis/ibis

echo 'Horizon x Cinerea x Rupestris SNP :: IBIS Without MAP'
dir="/media/yn259/data/research/HCR"
phy_ibis="$dir/snp/phy_ibis"
if [ ! -d "$phy_ibis" ]
then
	echo "creating ibis directory"
	mkdir "$phy_ibis"
fi
$plink --vcf $dir/snp/genotype.vcf --make-bed --vcf-half-call m --out $phy_ibis/genotype
$ibis -bfile $phy_ibis/genotype -ibd2 -printCoef -t 4 -f $phy_ibis/ibis

END


